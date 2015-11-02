import os

out = None

def render_copy(source):
	with open(source, "r") as fin:
		for line in fin:
			out.write(line)

def render_section_header(name, anchor):
	out.write('<h2><a id="{anchor}" class="anchor" href="#{anchor}" aria-hidden="true"><span class="octicon octicon-link"></span></a>{name}</h2>\n'.format(name=name, anchor=anchor))

def render_text(text):
	out.write("<p>%s</p>" % text)

def render_version(name, exact_version):
	out.write("<p style='font-weight: bold;'>Version %s (%s):</p><ul>" % (name, exact_version))

def render_version_entry(name, link):
	out.write("<li><a href='{link}'>{name}</a></li>".format(name=name, link=link))

def render_version_end(name):
	out.write("</ul>")

def render_section(name, folderid):
	render_section_header(name, folderid)
	for version in os.listdir(folderid):
		with open(os.path.join(folderid, version, "version.txt")) as f:
			exact_ssh = f.readline()
		render_version(version, exact_ssh)
		for entry in os.listdir(os.path.join(folderid, version)):
			render_version_entry(entry, os.path.join(folderid, version, entry))
		render_version_end(version)

def main():
	global out
	try:
		with open("index.html", "w") as o:
			out = o
			render_copy("header.html")
			render_section("Development builds", "dev-builds")
			render_copy("footer.html")
	finally:
		out = None

if __name__ == "__main__":
	main()
