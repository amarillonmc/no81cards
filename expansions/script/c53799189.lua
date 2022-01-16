local m=53799189
local cm=_G["c"..m]
cm.name="三G虎"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(cm.tgtg)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.seqcon)
	e3:SetTarget(cm.seqtg)
	e3:SetOperation(cm.seqop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():GetControler()~=e:GetHandler():GetOwner()end)
	e4:SetValue(function(e,c,sumtype)return sumtype==SUMMON_TYPE_FUSION end)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e7)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local z={}
	for i=0,4 do
		if Duel.CheckLocation(tp,LOCATION_MZONE,i) then table.insert(z,i) end
		if Duel.CheckLocation(1-tp,LOCATION_MZONE,i) then table.insert(z,i+16) end
	end
	local g=Duel.GetFieldGroup(tp,0xff,0)
	local seed=g:RandomSelect(tp,#z)
	local fc=seed:RandomSelect(tp,1):GetFirst()
	local ct=0
	for tc in aux.Next(seed) do
		ct=ct+1
		if tc==fc then break end
	end
	local s=z[ct]
	local p=tp
	if s>4 then p,s=1-tp,s-16 end
	Duel.SpecialSummon(c,0,tp,p,false,false,POS_FACEUP,1<<s)
end
function cm.tgtg(e,c)
	local seq=c:GetSequence()
	return seq<5 and (e:GetHandler()==c or e:GetHandler():GetColumnGroup():IsContains(c)) or (math.abs(e:GetHandler():GetSequence()-seq)==1 and c:GetControler()==e:GetHandler():GetControler())
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsControler(tp)
end
function cm.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-e:GetHandler():GetOwner())
end
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	local z={}
	for i=0,4 do
		if Duel.CheckLocation(tp,LOCATION_MZONE,i) then table.insert(z,i) end
		if Duel.CheckLocation(1-tp,LOCATION_MZONE,i) and c:IsControlerCanBeChanged() then table.insert(z,i+16) end
	end
	local g=Duel.GetFieldGroup(tp,0xff,0)
	local seed=g:RandomSelect(tp,#z)
	local fc=seed:RandomSelect(tp,1):GetFirst()
	local ct=0
	for tc in aux.Next(seed) do
		ct=ct+1
		if tc==fc then break end
	end
	local s=z[ct]
	if s<5 then Duel.MoveSequence(c,s) else Duel.GetControl(c,1-tp,0,0,1<<(s-16)) end
end
