from flask import Flask, render_template, request, redirect, url_for, session
import db
from passlib.context import CryptContext
password_ctx = CryptContext(schemes=['bcrypt'])


app = Flask(__name__)
app.secret_key = b"04faa708f84eb6603afed37dbf9ae1cd754f184ea7ac2c4aa3bb9711517107ad"

@app.route("/")
def index():
    return redirect(url_for("login"))


@app.route("/login", methods=["GET", "POST"])
def login():
    if "username" in session:
        return redirect(url_for("homepage"))
    if request.method == "POST":
        username = request.form["username"].strip()
        with db.connect() as conn:
            with conn.cursor() as cur:
                if username:
                    cur.execute("SELECT pseudo, mdp FROM utilisateur WHERE pseudo = %s", (username,))
                else:
                    return render_template("login.html")
                user = cur.fetchone()
        if user:
            valid_pass = password_ctx.verify(request.form["password"], user.mdp)
            if valid_pass:
                session["username"] = username
                return redirect(url_for("homepage"))
    return render_template("login.html")

@app.route("/inscription", methods=["GET", "POST"])
def inscription():
    password_ctx = CryptContext(schemes=['bcrypt'])
    if request.method == "POST":
        username = request.form["username"].strip()
        password = request.form["password"].strip()
        confirm = request.form["confirm_pass"].strip()
        email = request.form["email"].strip()
        if password != confirm:
            return redirect(url_for("inscription"))
        if username and password and email:
            hashed_pass = password_ctx.hash(password)
            with db.connect() as conn:
                with conn.cursor() as cur:
                    cur.execute("SELECT * FROM utilisateur WHERE pseudo = %s OR email = %s", (username, email))
                    already_exists = cur.fetchone()
                    if already_exists:
                        return redirect(url_for("inscription"))
                    cur.execute("INSERT INTO utilisateur (pseudo, mdp, email) VALUES (%s, %s, %s)", (username, hashed_pass, email))
                    session["username"] = username
            return redirect(url_for("homepage"))
    
    return render_template("inscription.html")


@app.route("/logout")
def logout():
    session.pop("username", None)
    return redirect(url_for("login"))
        
@app.route("/homepage")
def homepage():
    if "username" not in session :
        return redirect(url_for("login"))
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM popular_tracks NATURAL JOIN morceau NATURAL JOIN groupe ORDER BY nombre_ecoutes DESC LIMIT 10")
            popular_tracks = cur.fetchall()
            cur.execute("SELECT * FROM groupes_plus_suivis")
            popular_groups = cur.fetchall()
            cur.execute("SELECT id_alb,nom_album, nom_groupe,groupe.id_grp FROM album NATURAL JOIN groupe ORDER BY date_sortie DESC LIMIT 5")
            recent_albums = cur.fetchall()
    return render_template("homepage.html", tracks=popular_tracks, p_groups=popular_groups, albums=recent_albums)    

@app.route("/morceau<int:id_morceau>")
def morceau(id_morceau):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM morceau NATURAL JOIN groupe WHERE id_mor=%s", (id_morceau,))
            track = cur.fetchone()
            if not track:
                return render_template("morceau_not_found.html")
            cur.execute("SELECT nom_album, id_alb FROM album NATURAL JOIN contient WHERE id_mor=%s", (id_morceau,))
            albums = cur.fetchall()
            cur.execute("SELECT DISTINCT nom, prenom, id_art FROM participe NATURAL JOIN artiste NATURAL JOIN fait_partie WHERE id_grp = %s AND id_mor = %s", (track.id_grp, id_morceau))
            artists = cur.fetchall()
            cur.execute("SELECT DISTINCT nom, prenom, id_art FROM participe NATURAL JOIN artiste NATURAL JOIN fait_partie WHERE id_grp <> %s AND id_mor = %s and id_art NOT IN(SELECT id_art FROM fait_partie WHERE id_grp=%s)", (track.id_grp, id_morceau, track.id_grp))
            featuring = cur.fetchall()

    return render_template("morceau.html", track=track, albums=albums, artists=artists, featuring=featuring)

@app.route("/groupe<int:id_groupe>")
def groupe(id_groupe):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT DISTINCT id_art,nom, prenom FROM artiste NATURAL JOIN fait_partie NATURAL JOIN groupe WHERE id_grp=%s AND date_dep IS NULL", (id_groupe,))
            membres_actuels = cur.fetchall()
            cur.execute("SELECT DISTINCT id_art,nom, prenom FROM artiste NATURAL JOIN fait_partie NATURAL JOIN groupe WHERE id_grp=%s AND date_dep IS NOT NULL", (id_groupe,))
            membres_passés = cur.fetchall()
            cur.execute("SELECT * from morceau NATURAL JOIN groupe WHERE id_grp=%s", (id_groupe,))
            morceaux = cur.fetchall()
            cur.execute("SELECT * FROM album NATURAL JOIN groupe WHERE id_grp=%s", (id_groupe,))
            albums = cur.fetchall()
            cur.execute("SELECT * FROM groupe WHERE id_grp=%s", (id_groupe,))
            groupe = cur.fetchone()
            cur.execute("SELECT COUNT(*) as followers FROM est_abonne WHERE id_grp=%s", (id_groupe,))
            followers_count = cur.fetchone()
    if not groupe:
        return render_template("group_not_found.html")
    return render_template("groupe.html", membres_actuels=membres_actuels, membres_passés=membres_passés, tracks=morceaux, albums=albums, groupe=groupe, followers_count=followers_count)

@app.route("/album<int:id_album>")
def album(id_album):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id_alb, nom_album, nom_groupe,groupe.id_grp, date_sortie,description FROM album NATURAL JOIN groupe WHERE id_alb=%s", (id_album,))
            album = cur.fetchone()
            cur.execute("SELECT id_alb,titre,id_mor,num_tracklist FROM morceau NATURAL JOIN contient NATURAL JOIN album WHERE id_alb=%s  order by num_tracklist", (id_album,))
            tracks = cur.fetchall()
    if not album:
        return render_template("album_not_found.html")
    return render_template("album.html", album=album, tracks=tracks)

@app.route("/artiste<int:id_artiste>")
def artiste(id_artiste):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM artiste WHERE id_art=%s", (id_artiste,))
            artiste = cur.fetchone()
            cur.execute("SELECT * FROM fait_partie NATURAL JOIN groupe WHERE id_art=%s AND date_dep IS NULL", (id_artiste,))
            groupes_actuels = cur.fetchall()
            cur.execute("SELECT * FROM fait_partie NATURAL JOIN groupe WHERE id_art=%s AND date_dep IS NOT NULL", (id_artiste,))
            groupes_passés = cur.fetchall()
            cur.execute("SELECT * FROM participe NATURAL JOIN morceau natural join groupe WHERE id_art=%s", (id_artiste,))
            tracks= cur.fetchall()
    if not artiste:
        return render_template("artist_not_found.html")
    return render_template("artiste.html", artiste=artiste, groupes_actuels=groupes_actuels, groupes_passés=groupes_passés, tracks=tracks)

@app.route("/check_follow_status/<string:id_groupe>")
def check_follow_status(id_groupe):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM est_abonne WHERE pseudo=%s AND id_grp=%s", (session["username"], id_groupe))
            follow_status = cur.fetchone()
            if follow_status:
                return "followed"
            else:
                return "unfollowed"

@app.route("/get_followers_count/<int:id_groupe>")
def get_followers_count(id_groupe):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) as followers FROM est_abonne WHERE id_grp=%s", (id_groupe,))
            followers_count = cur.fetchone()
    return str(followers_count.followers) if followers_count else "0"

@app.route("/follow/<int:status>/<string:id_groupe>", methods=["POST"])
def follow(id_groupe, status):
    with db.connect() as conn:
        with conn.cursor() as cur:
            if request.method == "POST":
                if not status:
                    cur.execute("INSERT INTO est_abonne (pseudo, id_grp) VALUES (%s, %s)", (session["username"], id_groupe))
                else:
                    cur.execute("DELETE FROM est_abonne WHERE pseudo=%s AND id_grp=%s", (session["username"], id_groupe))
    return redirect(url_for("get_followers_count", id_groupe=id_groupe))


@app.route("/search", methods=["GET"])
def search():
    search = request.args.get("search_query")
    filter = request.args.get("Filter")
    if filter is None:
        filter = "tracks"
    filter = filter.lower()
    if filter != "users":
        search = search.title()
    
    if filter == "tracks":
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM morceau NATURAL JOIN groupe WHERE titre LIKE %s", (search+"%",))
                tracks = cur.fetchall()
        return render_template("search.html", tracks=tracks,search=search)
    elif filter == "albums":
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM album NATURAL JOIN groupe WHERE nom_album LIKE %s", (search+"%",))
                albums = cur.fetchall()
        return render_template("search.html", albums=albums,search=search)
    elif filter == "artists":
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM artiste WHERE nom LIKE %s or prenom like %s", (search+"%",search+"%"))
                artistes = cur.fetchall()
        return render_template("search.html", artists=artistes,search=search)
    elif filter == "groups":
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM groupe WHERE nom_groupe LIKE %s", (search+"%",))
                groupes = cur.fetchall()
        return render_template("search.html", groups=groupes,search=search)
    elif filter == "playlists":
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM playlist WHERE nom_playlist LIKE %s AND statut='public'", (search+"%",))
                playlists = cur.fetchall()
        return render_template("search.html", playlists=playlists,search=search)
    elif filter == "users":
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM utilisateur WHERE pseudo LIKE %s", (search+"%",))
                users = cur.fetchall()
        return render_template("search.html", users=users,search=search)
    elif filter == "genres":
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM groupe WHERE genre LIKE %s", (search+"%",))
                groupesgenre = cur.fetchall()
        return render_template("search.html", groupesgenre=groupesgenre,search=search)
    else:
        return render_template("search.html")

@app.route("/playing<string:id_morceau>")
def playing(id_morceau):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM morceau NATURAL JOIN groupe WHERE id_mor=%s", (id_morceau,))
            track = cur.fetchone()
            cur.execute("INSERT INTO ecoute (pseudo, id_mor) VALUES (%s, %s)", (session["username"], id_morceau))
    return render_template("playing.html", track=track)

@app.route("/playlist<int:id_playlist>")
def playlist(id_playlist):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM playlist WHERE id_pl=%s", (id_playlist,))
            playlist = cur.fetchone()
            cur.execute("SELECT * FROM est_dans NATURAL JOIN morceau WHERE id_pl=%s", (id_playlist,))
            tracks = cur.fetchall()
    if not playlist:
        return render_template("playlist_not_found.html")
    return render_template("playlist.html", playlist=playlist, tracks=tracks, owner=playlist.proprietaire == session["username"])

@app.route("/create_playlist", methods=["GET", "POST"])
def create_playlist():
    if request.method == "POST":
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("INSERT INTO playlist (nom_playlist, proprietaire,description_playlist,statut) VALUES (%s, %s, %s, %s)", (request.form["playlist_name"], session["username"], request.form["description"], request.form["statut"]))
                return redirect(url_for('profile', username=session['username']))
    return render_template("create_playlist.html")

@app.route("/delete_playlist/<int:id_playlist>")
def delete_playlist(id_playlist):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM playlist WHERE id_pl=%s", (id_playlist,))
    return redirect(url_for("profile", username=session["username"]))   

@app.route("/add_to_playlist/<int:id_morceau>", methods=["POST","GET"] )
def add_to_playlist(id_morceau):
    if request.method == "POST":
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM playlist WHERE proprietaire=%s", (session["username"],))
                playlists = cur.fetchall()
        if not playlists:
            return redirect(url_for("add_to_playlist", id_morceau=id_morceau))
        playlist = request.form["playlist"]
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT id_pl,id_mor FROM est_dans WHERE id_pl=%s AND id_mor=%s", (playlist, id_morceau))
                already_in = cur.fetchone()
                if not already_in:
                    cur.execute("INSERT INTO est_dans (id_pl, id_mor) VALUES (%s, %s)", (playlist, id_morceau))
        return redirect(url_for("morceau",id_morceau=id_morceau ))
    else:
        with db.connect() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM playlist WHERE proprietaire=%s", (session["username"],))
                playlists = cur.fetchall()
                cur.execute("SELECT * FROM morceau WHERE id_mor=%s", (id_morceau,))
                track = cur.fetchone()
        return render_template("add_to_playlist.html", playlists=playlists, track=track)

@app.route("/remove_from_playlist/<int:id_morceau>/<int:id_playlist>")
def remove_from_playlist(id_morceau, id_playlist):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id_pl,id_mor FROM est_dans natural join playlist WHERE id_pl=%s AND id_mor=%s  AND proprietaire = %s ", (id_playlist, id_morceau, session["username"]))
            already_in = cur.fetchone()
            if already_in:
                cur.execute("DELETE FROM est_dans WHERE id_pl=%s AND id_mor=%s", (id_playlist, id_morceau))
    return redirect(url_for("playlist", id_playlist=id_playlist))

@app.route("/check_playlist_status/<int:id_playlist>")
def check_playlist_status(id_playlist):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT statut FROM playlist WHERE id_pl=%s", (id_playlist,))
            status = cur.fetchone()
            return str(status.statut)


@app.route("/change_playlist_status/<int:status>/<int:id_playlist>", methods=["POST"])
def change_playlist_status(id_playlist, status):
    with db.connect() as conn:
        with conn.cursor() as cur:
            if request.method == "POST":
                if not status:
                    cur.execute("UPDATE playlist SET statut = 'private' WHERE id_pl=%s", (id_playlist,))
                else:
                    cur.execute("UPDATE playlist SET statut = 'public' WHERE id_pl=%s", (id_playlist,))
    return redirect(url_for("check_playlist_status", id_playlist=id_playlist))

@app.route("/change_playlist_description/<int:id_playlist>", methods=["GET","POST"])
def change_playlist_description(id_playlist):
    with db.connect() as conn:
        with conn.cursor() as cur:
            if request.method == "POST":
                cur.execute("UPDATE playlist SET description_playlist = %s WHERE id_pl=%s", (request.form["description"], id_playlist))
            else:
                return render_template("change_playlist_description.html", id_playlist=id_playlist)
    return redirect(url_for("playlist", id_playlist=id_playlist))

@app.route("/playlists")
def playlists():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM playlist WHERE statut='public' ORDER BY proprietaire")
            playlists = cur.fetchall()
    return render_template("public_playlists.html", playlists=playlists,current_user=session["username"])

@app.route("/check_favorite_status/<int:id_morceau>")
def check_favori_status(id_morceau):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM mets_en_favoris WHERE pseudo=%s AND id_mor=%s", (session["username"], id_morceau))
            favori_status = cur.fetchone()
            if favori_status:
                return "favorited"
            else:
                return "unfavorited"
            
@app.route("/favorite/<int:status>/<int:id_morceau>", methods=["POST"])
def favorite(id_morceau, status):
    with db.connect() as conn:
        with conn.cursor() as cur:
            if request.method == "POST":
                if not status:
                    cur.execute("INSERT INTO mets_en_favoris (pseudo, id_mor) VALUES (%s, %s)", (session["username"], id_morceau))
                else:
                    cur.execute("DELETE FROM mets_en_favoris WHERE pseudo=%s AND id_mor=%s", (session["username"], id_morceau))
    return redirect(url_for("check_favori_status", id_morceau=id_morceau))

@app.route("/check_album_favorite_status/<int:id_album>")
def check_album_favori_status(id_album):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM mets_album_favoris WHERE pseudo=%s AND id_alb=%s", (session["username"], id_album))
            favori_status = cur.fetchone()
            if favori_status:
                return "favorited"
            else:
                return "unfavorited"

@app.route("/favorite_album/<int:status>/<int:id_album>", methods=["POST"])
def favorite_album(id_album, status):
    with db.connect() as conn:
        with conn.cursor() as cur:
            if request.method == "POST":
                if not status:
                    cur.execute("INSERT INTO mets_album_favoris (pseudo, id_alb) VALUES (%s, %s)", (session["username"], id_album))
                else:
                    cur.execute("DELETE FROM mets_album_favoris WHERE pseudo=%s AND id_alb=%s", (session["username"], id_album))
    return redirect(url_for("check_album_favori_status", id_album=id_album))

@app.route("/check_save_status/<int:id_playlist>")
def check_save_status(id_playlist):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM sauvegarde_playlist WHERE pseudo=%s AND id_pl=%s", (session["username"], id_playlist))
            save_status = cur.fetchone()
            if save_status:
                return "saved"
            else:
                return "unsaved"
            
@app.route("/save/<int:status>/<int:id_playlist>", methods=["POST"])
def save(id_playlist, status):
    with db.connect() as conn:
        with conn.cursor() as cur:
            if request.method == "POST":
                if not status:
                    cur.execute("INSERT INTO sauvegarde_playlist (pseudo, id_pl) VALUES (%s, %s)", (session["username"], id_playlist))
                else:
                    cur.execute("DELETE FROM sauvegarde_playlist WHERE pseudo=%s AND id_pl=%s", (session["username"], id_playlist))
    return redirect(url_for("check_save_status", id_playlist=id_playlist))

@app.route("/profile<string:username>")
def profile(username=None):
    if username is None:
        username = session["username"]
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM utilisateur WHERE pseudo=%s", (username,))
            user = cur.fetchone()
            cur.execute("SELECT * FROM est_abonne NATURAL JOIN groupe WHERE pseudo=%s", (username,))
            followed_groups = cur.fetchall()
            if username == session["username"]:
                cur.execute("SELECT * FROM suit JOIN playlist ON following = proprietaire WHERE follower= %s AND statut='public' AND date_creation >= CURRENT_TIMESTAMP - INTERVAL '6 months' ORDER BY date_creation, following DESC LIMIT 5", (username,))
                recent_playlists = cur.fetchall()
                cur.execute("SELECT * FROM est_abonne NATURAL JOIN groupe NATURAL JOIN morceau WHERE pseudo= %s AND date_pub >= CURRENT_DATE - INTERVAL '6 months' ORDER BY date_pub, nom_groupe DESC LIMIT 5", (username,))
                recent_tracks = cur.fetchall()
                cur.execute("SELECT * FROM est_abonne NATURAL JOIN groupe NATURAL JOIN album WHERE pseudo= %s AND date_sortie >= CURRENT_DATE - INTERVAL '6 months' ORDER BY date_sortie, nom_groupe DESC LIMIT 5", (username,))
                recent_albums = cur.fetchall()
                cur.execute("SELECT * FROM playlist WHERE proprietaire=%s", (username,))
            else:
                recent_albums, recent_playlists, recent_tracks = None, None, None
                cur.execute("SELECT * FROM playlist WHERE proprietaire=%s AND statut='public'", (username,))
            my_playlists = cur.fetchall()
            cur.execute("SELECT id_mor, titre, COUNT(*) as nbr_ecoutes FROM ecoute NATURAL JOIN morceau where pseudo=%s GROUP BY id_mor, titre ORDER BY nbr_ecoutes DESC LIMIT 5", (username,))
            most_listened = cur.fetchall()
            cur.execute("SELECT id_mor, titre,pseudo,date_ecoute FROM ( ecoute NATURAL JOIN morceau) as p1 where p1.pseudo=%s and date_ecoute>ALL(select date_ecoute from ecoute where ecoute.id_mor=p1.id_mor and p1.pseudo=pseudo and p1.date_ecoute!=date_ecoute) ORDER BY p1.date_ecoute desc LIMIT 5", (username,))
            track_history = cur.fetchall()
            cur.execute("SELECT COUNT(*) as followers FROM suit WHERE following=%s", (username,))
            followers=cur.fetchone()
            cur.execute("SELECT COUNT(*) as following FROM suit WHERE follower=%s", (username,))
            following=cur.fetchone()
    if not user:
        return render_template("profile_not_found.html")
    print(recent_albums)
    return render_template("profile.html", user=user, followed_groups=followed_groups, my_playlists=my_playlists, most_listened=most_listened, track_history=track_history, followers=followers, following=following, recent_albums=recent_albums, recent_playlists=recent_playlists, recent_tracks=recent_tracks)

@app.route("/check_user_following_status/<string:username>")
def check_user_following_status(username):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM suit WHERE follower=%s AND following=%s", (session["username"], username))
            follow_status = cur.fetchone()
            if follow_status:
                return "following"
            else:
                return "not_following"

@app.route("/follow_user/<int:status>/<string:username>", methods=["POST"])
def follow_user(username, status):
    with db.connect() as conn:
        with conn.cursor() as cur:
            if request.method == "POST":
                if not status:
                    cur.execute("INSERT INTO suit (follower, following) VALUES (%s, %s)", (session["username"], username))
                else:
                    cur.execute("DELETE FROM suit WHERE follower=%s AND following=%s", (session["username"], username))
    return redirect(url_for("check_user_following_status", username=username))
    
@app.route("/get_user_follower_count/<string:username>")
def get_user_follower_count(username):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) as followers FROM suit WHERE following=%s", (username,))
            followers_count = cur.fetchone()
    return str(followers_count.followers) if followers_count else "0"

@app.route("/favourites<string:username>")
def favourites(username=None):
    if username is None:
        username = session["username"]
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM utilisateur WHERE pseudo=%s", (username,))
            user = cur.fetchone()
            cur.execute("SELECT * FROM sauvegarde_playlist NATURAL JOIN playlist WHERE pseudo=%s", (username,))
            saved_playlists = cur.fetchall()
            cur.execute("SELECT * FROM mets_en_favoris NATURAL JOIN morceau WHERE pseudo=%s", (username,))
            favourite_tracks = cur.fetchall()
            cur.execute("SELECT * FROM mets_album_favoris NATURAL JOIN album WHERE pseudo=%s", (username,))
            favourite_albums = cur.fetchall()
    if not user:
        return render_template("profile_not_found.html")
    return render_template("favourites.html", user=user, saved_playlists=saved_playlists, favourite_tracks=favourite_tracks, favourite_albums=favourite_albums)

@app.route("/settings", methods=["GET", "POST"])
def settings():
    if request.method == "POST":
        old_password, new_password, new_confirm, new_email, delete_account = None, None, None, None, None
        if "old_password" in request.form:
            old_password = request.form["old_password"]
        if "new_password" in request.form:
            new_password = request.form["new_password"]
        if "new_confirm" in request.form:
            new_confirm = request.form["new_confirm"]
        if "new_email" in request.form:
            new_email = request.form["new_email"]
        if "del_account" in request.form:
            delete_account = request.form["del_account"]
        if old_password and new_password and new_confirm:
            with db.connect() as conn:
                with conn.cursor() as cur:
                    cur.execute("SELECT mdp FROM utilisateur WHERE pseudo = %s", (session["username"],))
                    user = cur.fetchone()
                    valid_pass = password_ctx.verify(old_password, user.mdp)
                    if valid_pass:
                        hashed_pass = password_ctx.hash(new_password)
                        cur.execute("UPDATE utilisateur SET mdp = %s WHERE pseudo = %s", (hashed_pass, session["username"]))
                    else:
                        return redirect(url_for("settings"))
        if new_email:
            with db.connect() as conn:
                with conn.cursor() as cur:
                    cur.execute("UPDATE utilisateur SET email = %s WHERE pseudo = %s", (new_email, session["username"]))
        if delete_account:
            with db.connect() as conn:
                with conn.cursor() as cur:
                    cur.execute("SELECT mdp FROM utilisateur WHERE pseudo = %s", (session["username"],))
                    user = cur.fetchone()
                    valid_pass = password_ctx.verify(delete_account, user.mdp)
                    if valid_pass:      
                        cur.execute("DELETE FROM utilisateur WHERE pseudo = %s", (session["username"],))
                        session.pop("username", None)
                        return redirect(url_for("login"))
    return render_template("settings.html")

@app.route("/suggestions")
def suggestions():
    with db.connect() as conn:
        with conn.cursor() as cur:
            #suggestion d'album contenant des morceaux que l'utilisateur a écouté
            cur.execute("SELECT DISTINCT nom_album, id_alb,album.id_grp,nom_groupe FROM groupe NATURAL JOIN album NATURAL JOIN contient NATURAL JOIN morceau NATURAL JOIN ecoute  WHERE pseudo=%s", (session["username"],))
            albums = cur.fetchall()
            #suggestion de morceaux par (le meme groupe que l'utilisateur a écouté)
            cur.execute("SELECT DISTINCT m.titre, m.id_mor, m.id_grp,m.nom_groupe FROM (ecoute NATURAL JOIN morceau NATURAL JOIN groupe) AS ecoute1 JOIN (morceau NATURAL JOIN groupe) AS m ON ecoute1.id_grp=m.id_grp WHERE ecoute1.pseudo=%s AND m.id_mor NOT IN (SELECT DISTINCT id_mor FROM ecoute WHERE pseudo=%s)", (session["username"], session["username"]))
            tracks = cur.fetchall()
            #suggestion de playlist contenant des morceaux que l'utilisateur a écouté
            cur.execute("SELECT DISTINCT nom_playlist, id_pl, proprietaire FROM playlist p1 NATURAL JOIN morceau NATURAL JOIN ecoute WHERE pseudo=%s AND id_mor IN (SELECT id_mor FROM playlist p2 NATURAL JOIN est_dans WHERE p1.id_pl = p2.id_pl) EXCEPT SELECT DISTINCT nom_playlist, id_pl, proprietaire FROM playlist WHERE proprietaire = %s OR statut='private' ", (session["username"],session["username"]))
            playlists = cur.fetchall()
            #suggestion de groupe suivis par les personnes que l'utilisateur suit
            cur.execute("SELECT DISTINCT nom_groupe,id_grp FROM (SELECT * FROM est_abonne NATURAL JOIN groupe WHERE est_abonne.pseudo !=%s) AS abonne NATURAL JOIN est_abonne WHERE est_abonne.pseudo IN (SELECT suit.following FROM suit WHERE suit.follower=%s) EXCEPT SELECT nom_groupe,id_grp FROM est_abonne NATURAL JOIN groupe WHERE pseudo=%s ", (session["username"], session["username"], session["username"]))
            groups = cur.fetchall()
            #suggestion de personnes suivis par les personnes que l'utilisateur suit
            cur.execute("SELECT DISTINCT following FROM (SELECT suit.following FROM suit WHERE suit.follower !=%s) AS suivre NATURAL JOIN suit WHERE suit.follower IN (SELECT suit.following FROM suit WHERE suit.follower=%s) EXCEPT SELECT following FROM suit WHERE follower=%s OR following =%s", (session["username"], session["username"], session["username"],session["username"]))
            users = cur.fetchall()
            #suggestion de morceaux du (groupe que l'utilisateur a le plus écouté) mais que l'utilisateur n'a pas écouté:
            cur.execute("SELECT DISTINCT morceau.titre, morceau.id_mor,id_grp,nom_groupe FROM morceau NATURAL JOIN groupe WHERE id_grp=(SELECT groupe.id_grp FROM groupe NATURAL JOIN morceau NATURAL JOIN  ecoute WHERE pseudo=%s GROUP BY groupe.id_grp ORDER BY COUNT(*) DESC LIMIT 1) AND morceau.id_mor NOT IN (SELECT DISTINCT morceau.id_mor FROM morceau NATURAL JOIN ecoute WHERE pseudo=%s)", (session["username"], session["username"]))
            missing_tracks = cur.fetchall()
            #top streamed group
            cur.execute("SELECT nom_groupe,id_grp FROM groupe NATURAL JOIN morceau NATURAL JOIN ecoute WHERE pseudo=%s GROUP BY groupe.id_grp,nom_groupe ORDER BY COUNT(*) DESC LIMIT 1", (session["username"],))
            top_streamed_group = cur.fetchone()
    if albums or playlists or groups or users or missing_tracks or tracks:
        return render_template("suggestions.html", albums=albums, playlists=playlists, groups=groups, users=users, missing_tracks=missing_tracks, tracks=tracks, top_streamed_group=top_streamed_group)
    return render_template("suggestions_not_found.html")

@app.route("/followers/<string:username>")
def followers(username):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT follower FROM suit WHERE following=%s", (username,))
            followers = cur.fetchall()
            return render_template("followers.html", followers=followers)
        
@app.route("/following/<string:username>")
def following(username):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT following FROM suit WHERE follower=%s", (username,))
            following = cur.fetchall()
            print(following)
            return render_template("following.html", following=following)
        
@app.route("/followedgroups/<string:username>")
def followedgroups(username):
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT nom_groupe,id_grp FROM groupe NATURAL JOIN est_abonne WHERE pseudo=%s", (username,))
            followedgroups = cur.fetchall()
            return render_template("followedgroups.html", groups=followedgroups)


            


if __name__ == "__main__" :
    app.run(debug=True)
