{% if theme.gitment.enable %}
    {% set owner = theme.gitment.owner %}
    {% set repo = theme.gitment.repo %}
    {% set cid = theme.gitment.client_id %}
    {% set cs = theme.gitment.client_secret %}
    <link rel="stylesheet" href="https://imsun.github.io/gitment/style/default.css">
    <script src="https://imsun.github.io/gitment/dist/gitment.browser.js"></script>
    {% if theme.gitment.lazy %}
        <script type="text/javascript">
            function showGitment(){
                document.getElementById("gitment-display-button").style.display = "none";
                document.getElementById("gitment-container").style.display = "block";
                var gitment = new Gitment({
                        id: window.location.pathname, 
                        owner: '{{owner}}',
                        repo: '{{repo}}',
                        oauth: {
                            client_id: '{{cid}}',
                            client_secret: '{{cs}}',
                        }});
                gitment.render('gitment-container');
            }
        </script>
    {% else %}
        <script type="text/javascript">
            var gitment = new Gitment({
                    id: window.location.pathname, 
                    owner: '{{owner}}',
                    repo: '{{repo}}',
                    oauth: {
                        client_id: '{{cid}}',
                        client_secret: '{{cs}}',
                    }});
            gitment.render('gitment-container');
        </script>
    {% endif %}
{% endif %}