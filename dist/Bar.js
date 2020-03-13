// Generated by CoffeeScript 2.5.0
(function() {
  var Bar, StyleContext, cn, css,
    boundMethodCheck = function(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new Error('Bound instance method accessed before binding'); } };

  css = require('./Style.less');

  cn = require('classnames');

  ({StyleContext} = require('./Style.coffee'));

  Bar = class Bar extends Component {
    constructor(props) {
      super(props);
      this.baseRef = this.baseRef.bind(this);
    }

    baseRef(el) {
      boundMethodCheck(this, Bar);
      return this.base = el;
    }

    render() {
      var bar_props, style;
      style = Object.assign({}, this.props.style);
      if (this.props.margin_left || this.props.margin_top || this.props.margin_bottom || this.props.margin_right) {
        style.marginLeft = this.props.margin_left && DIM * 1 / 8 || '0px';
        style.marginRight = this.props.margin_right && DIM * 1 / 8 || '0px';
        style.marginBottom = this.props.margin_bottom && DIM * 1 / 8 || '0px';
        style.marginTop = this.props.margin_top && DIM * 1 / 8 || '0px';
      }
      bar_props = {
        ref: this.baseRef,
        className: cn(this.props.className, this.props.btn && css['bar-btn'], this.props.vert && css['bar-vert'], css['bar'], this.props.big && css['bar-big'] || css['bar-small']),
        style: style
      };
      return h('div', bar_props, this.props.children);
    }

  };

  module.exports = Bar;

}).call(this);

//# sourceMappingURL=Bar.js.map
