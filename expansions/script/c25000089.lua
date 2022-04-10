local m=25000089
local cm=_G["c"..m]
cm.name="炎拳"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)>0 end
	local fdzone=0
	for i=0,4 do
		if not Duel.GetFieldCard(tp,LOCATION_MZONE,i) then fdzone=fdzone|1<<i end
		if not Duel.GetFieldCard(1-tp,LOCATION_MZONE,i) then fdzone=fdzone|1<<(i+16) end
	end
	local exzone=0x60
	for i=5,6 do
		if Duel.GetFieldCard(tp,LOCATION_MZONE,i) then exzone=(1<<i)~exzone end
		if Duel.GetFieldCard(1-tp,LOCATION_MZONE,i) then exzone=(1<<(11-i))~exzone end
	end
	fdzone=fdzone|exzone
	local g=Duel.GetMatchingGroup(function(c)return c:GetSequence()>4 end,tp,0,LOCATION_MZONE,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local b1,b2=0,0
		for tc in aux.Next(g) do
			if tc:GetSequence()==5 then b2=1 end
			if tc:GetSequence()==6 then b1=1 end
		end
		local op=0
		if b1>0 and b2>0 then op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3)) elseif b1>0 then op=Duel.SelectOption(tp,aux.Stringid(m,2)) else op=Duel.SelectOption(tp,aux.Stringid(m,3))+1 end
		local sbzone=0
		if op==0 then sbzone=0x20 else sbzone=0x40 end
		e:SetLabel(sbzone)
		Duel.Hint(HINT_ZONE,tp,sbzone)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		local z=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,fdzone)
		e:SetLabel(z)
		Duel.Hint(HINT_ZONE,tp,z)
	end
end
function cm.tgfilter1(c,tp,p,seq)
	local sseq,sp=c:GetSequence(),c:GetControler()
	if seq<5 and sseq<5 then return sp==p and math.abs(sseq-seq)==1 end
	if p==tp then
		if seq<5 and sseq>=5 then return (seq==1 and ((sseq==5 and sp==tp) or (sseq==6 and sp~=tp))) or (seq==3 and ((sseq==6 and sp==tp) or (sseq==5 and sp~=tp))) end
		if seq>4 then return (seq==5 and ((sseq==1 and sp==tp) or (sseq==3 and sp~=tp))) or (seq==6 and ((sseq==3 and sp==tp) or (sseq==1 and sp~=tp))) end
	else
		if seq<5 and sseq>=5 then return (seq==3 and ((sseq==5 and sp==tp) or (sseq==6 and sp~=tp))) or (seq==1 and ((sseq==6 and sp==tp) or (sseq==5 and sp~=tp))) end
		if seq>4 then return (seq==6 and ((sseq==1 and sp==tp) or (sseq==3 and sp~=tp))) or (seq==5 and ((sseq==3 and sp==tp) or (sseq==1 and sp~=tp))) end
	end
end
function cm.tgfilter2(g,tp)
	local sg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local fid=tc:GetFieldID()
		tc:RegisterFlagEffect(m+10000,RESET_CHAIN,0,1,fid)
		local lg=Duel.GetMatchingGroup(cm.tgfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp,tc:GetControler(),tc:GetSequence())
		for sc in aux.Next(lg) do
			sc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,fid)
			sg:AddCard(sc)
		end
	end
	return sg
end
function cm.tgfilter3(c,g)
	for tc in aux.Next(g) do
		local fid=tc:GetFlagEffectLabel(m+10000)
		if fid~=nil and c:GetFlagEffectLabel(m)==fid then return true end
	end
	return false
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local z=e:GetLabel()
	local tc=nil
	if z&0x60==0 then
		local seq=math.log(z,2)
		if seq<5 then tc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq) end
		if seq>15 then tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq-16) end
	else
		if z&0x20==0x20 then
			if Duel.GetFieldCard(tp,LOCATION_MZONE,5) then tc=Duel.GetFieldCard(tp,LOCATION_MZONE,5) end
			if Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) then tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) end
		elseif z&0x40==0x40 then
			if Duel.GetFieldCard(tp,LOCATION_MZONE,6) then tc=Duel.GetFieldCard(tp,LOCATION_MZONE,6) end
			if Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) then tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) end
		end
	end
	if not tc then return end
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-800)
	local lg=cm.tgfilter2(Group.FromCards(tc),tp)
	Duel.HintSelection(Group.FromCards(tc))
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup()
	local sg=lg:Filter(cm.tgfilter3,nil,og)
	while sg:GetCount()>0 do
		Duel.BreakEffect()
		lg=cm.tgfilter2(sg,tp)
		Duel.HintSelection(sg)
		if Duel.SendtoGrave(sg,REASON_EFFECT)==0 then return end
		og=Duel.GetOperatedGroup()
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-og:GetCount()*800)
		sg=lg:Filter(cm.tgfilter3,nil,og)
	end
end
