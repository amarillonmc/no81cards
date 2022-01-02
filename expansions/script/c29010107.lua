--风色诗人·温迪
local m=29010107
local cm=_G["c"..m]
if windy then return end
windy=cm
function windy.add_freecheck(c)
	local tc=c
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(0x7f)
	e3:SetCode(29010100)
	tc:RegisterEffect(e3)
	return e3
end
if not cm then return end
function cm.initial_effect(c)
	aux.AddCodeList(c,29010100)
	--code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(29010100)
	c:RegisterEffect(e2)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.sptg2)
	e3:SetOperation(cm.spop2)
	c:RegisterEffect(e3)
	--Poetry of Balbatos
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(cm.cost)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
end
function cm.filter(c,e,tp)
	return c:IsCode(29010100) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.tdcheck(c)
	return (c:IsCode(29010100) or c:GetEffectCount(29010100)>0) and c:IsAbleToDeckAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdcheck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=Duel.SelectMatchingCard(tp,cm.tdcheck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(dg,nil,2,REASON_COST)
end
function cm.seqfilter(c,seq,g)
	local cseq=c:GetSequence()
	if cseq>=5 then return false end
	return cseq==seq and g:IsContains(c) 
end
function cm.seqcheck(c,seq)
	local cseq=c:GetSequence()
	return math.abs(cseq-seq)==1
end
function cm.checkmove1(c,seq)
	return c:GetSequence()>seq
end
function cm.checkmove2(c,seq)
	return c:GetSequence()<seq
end
function cm.descheck(c,tp)
	local cseq=c:GetSequence()
	local flag=false
	if cseq==5 then return false end
	if cseq==0 then 
		for i=1,3 do
			if Duel.CheckLocation(tp,LOCATION_MZONE,i) and Duel.IsExistingMatchingCard(cm.checkmove1,tp,LOCATION_MZONE,0,1,nil,i) then
				flag=true
			end
		end
	end
	if cseq==4 then 
		for i=1,3 do
			if Duel.CheckLocation(tp,LOCATION_MZONE,i) and Duel.IsExistingMatchingCard(cm.checkmove2,tp,LOCATION_MZONE,0,1,nil,i) then
				flag=true
			end
		end
	end
	if cseq~=0 and cseq~=4 then
		for i=1,cseq do
			if Duel.CheckLocation(tp,LOCATION_MZONE,i) and Duel.IsExistingMatchingCard(cm.checkmove2,tp,LOCATION_MZONE,0,1,nil,i) then
				flag=true
			end
		end
		for i=cseq,3 do
			if Duel.CheckLocation(tp,LOCATION_MZONE,i) and Duel.IsExistingMatchingCard(cm.checkmove1,tp,LOCATION_MZONE,0,1,nil,i) then
				flag=true
			end
		end
	end
	return flag
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local filter=0
	for i=0,4 do
		filter=filter|1<<(i+16)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,0,LOCATION_MZONE,filter)
	local seq=math.log(flag>>16,2)
	local g=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq)
	e:SetLabel(seq)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=e:GetLabel()
	local sc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq)
	Duel.Destroy(sc,REASON_EFFECT)
	if seq~=4 and seq~=0 then
		for i=seq-1,0,-1 do
			local mc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,i)
			if mc and Duel.CheckLocation(1-tp,LOCATION_MZONE,i+1) and not mc:IsImmuneToEffect(e) then
				Duel.MoveSequence(mc,i+1)
			end
		end
		for i=seq+1,4 do
			local mc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,i)
			if mc and Duel.CheckLocation(1-tp,LOCATION_MZONE,i-1) and not mc:IsImmuneToEffect(e) then
				Duel.MoveSequence(mc,i-1)
			end
		end
	elseif seq==4 then
		for i=3,0,-1 do
			local mc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,i)
			if mc and Duel.CheckLocation(1-tp,LOCATION_MZONE,i+1) and not mc:IsImmuneToEffect(e) then
				Duel.MoveSequence(mc,i+1)
			end
		end
	elseif seq==0 then
		for i=seq+1,4 do
			local mc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,i)
			if mc and Duel.CheckLocation(1-tp,LOCATION_MZONE,i-1) and not mc:IsImmuneToEffect(e) then
				Duel.MoveSequence(mc,i-1)
			end
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsCode(29010100) and c:IsAbleToGrave() end,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end