{% if python3 == True %}%if 0%{?fedora} > 12
%global with_python3 1
%endif{%endif%}

%global modname {{modname}}

Name:               python-{{barename}}
Version:            {{version}}
Release:            1%{?dist}
Summary:            {{summary}}

Group:              Development/Libraries
License:            {{license}}
URL:                {{URL}}
Source0:            {{_source0}}

{% if (arch == False) %}BuildArch:          noarch
{% endif %}

BuildRequires:      python2-devel

{%if python3%}%if 0%{?with_python3}
BuildRequires:      python3-devel
%endif{%endif%}

%description
{{description}}

{%if python3%}%if 0%{?with_python3}
%package -n python3-{{barename}}
Summary:            {{summary}}
Group:              Development/Libraries

%description -n python3-{{barename}}
{{description}}
%endif{%endif%}

%prep
%setup -q -n %{modname}-%{version}

# Remove bundled egg-info in case it exists
rm -rf %{modname}.egg-info
{%if python3%}%if 0%{?with_python3}
rm -rf %{py3dir}
cp -a . %{py3dir}
%endif{%endif%}

%build
{% if (arch == True) %}CFLAGS="$RPM_OPT_FLAGS" %{__python2} setup.py build
{%if python3%}%if 0%{?with_python3}
pushd %{py3dir}
CFLAGS="$RPM_OPT_FLAGS" %{__python3} setup.py build
popd
%endif{%endif%}{% else %}%{__python2} setup.py build
{%if python3%}%if 0%{?with_python3}
pushd %{py3dir}
%{__python3} setup.py build
popd
%endif
{% endif %}{%endif%}

%install
{%if python3%}%if 0%{?with_python3}
pushd %{py3dir}
%{__python3} setup.py install -O1 --skip-build --root=%{buildroot}
popd
%endif{%endif%}
%{__python2} setup.py install -O1 --skip-build --root=%{buildroot}

%check
%{__python2} setup.py test
{%if python3%}%if 0%{?with_python3}
pushd %{py3dir}
%{__python3} setup.py test
popd
%endif{%endif%}

%files
%doc README.rst LICENSE
{% if (arch == False) %}%{python2_sitelib}/%{modname}/
%{python2_sitelib}/%{modname}-%{version}*
{% else %}%{python2_sitearch}/%{modname}/
%{python2_sitearch}/%{modname}-%{version}*
{% endif %}
{%if python3%}%if 0%{?with_python3}
%files -n python3-{{barename}}
%doc README.rst LICENSE
{% if (arch == False) %}%{python3_sitelib}/%{modname}/
%{python3_sitelib}/%{modname}-%{version}-*
{% else %}%{python3_sitearch}/%{modname}/
%{python3_sitearch}/%{modname}-%{version}*
{% endif %}
%endif{%endif%}

%changelog
* {{date}} {{packager}} <{{email}}> {{version}}-1
- initial package for Fedora
