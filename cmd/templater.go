package cmd

//Templater interface for rendering templates
type Templater interface {
	getTemplate() string
}

func renderTemplate(t *Templater) (err error) {
	return
}
