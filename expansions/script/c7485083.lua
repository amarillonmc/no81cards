--拿非利的神金巨像
local s,id,o=GetID()
local m=id
local cm=_G["c"..m]

cm.named_with_God_Gold=1

function cm.God_Gold(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_God_Gold
end

function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetCode(EFFECT_SPSUMMON_PROC)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e01:SetValue(SUMMON_TYPE_RITUAL)
	e01:SetCondition(cm.spcon)
	e01:SetOperation(cm.spcop)
	c:RegisterEffect(e01)
	--special summon
	local e02=Effect.CreateEffect(c)
	e02:SetDescription(aux.Stringid(m,0))
	e02:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e02:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e02:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e02:SetCode(EVENT_TO_GRAVE)
	e02:SetCountLimit(1,m)
	e02:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		local ge1=Effect.CreateEffect(e:GetHandler())
		ge1:SetDescription(aux.Stringid(m,5))
		ge1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		ge1:SetType(EFFECT_TYPE_SINGLE)
		local ge01=Effect.CreateEffect(e:GetHandler())
		ge01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge01:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge01:SetTargetRange(0xff,0)
		ge01:SetTarget(function(e,c)
			return c:IsCode(7485083) 
		end)
		ge01:SetLabelObject(ge1)
		Duel.RegisterEffect(ge01,tp)
	end)
	e02:SetTarget(cm.target)
	e02:SetOperation(cm.operation)
	c:RegisterEffect(e02)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.placetg)
	e3:SetOperation(cm.placeop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(cm.mvcon)
	e4:SetTarget(cm.mvtg)
	e4:SetOperation(cm.mvop)
	c:RegisterEffect(e4)
end
function cm.lv(c)
	return 8
end
function cm.spcfilter(c,e,tp)
	return c==e:GetHandler()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local m1=Duel.GetRitualMaterial(tp)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:RemoveCard(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,9,"Greater")
	local res=mg:CheckSubGroup(aux.RitualCheck,1,9,tp,c,9,"Greater")
	aux.GCheckAdditional=nil
	return res
end
function cm.spcop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if not c then return false end
	local mg=Duel.GetRitualMaterial(tp)
	mg:RemoveCard(c)
	if c then
		local mg=mg:Filter(Card.IsCanBeRitualMaterial,c,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(c,8,"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,8,tp,c,8,"Greater")
		aux.GCheckAdditional=nil
		c:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
	end
end
function cm.hintfilter(c,id)
	return c:GetOriginalCode()==id
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.hintfilter,tp,0xff,0,nil,m)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(0,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	end
end
function cm.filter(c,e,sp)
	return c:IsFaceup() and cm.God_Gold(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,sp,false,true)
end
function cm.filter2(c,e,sp)
	return c:IsCode(7485071) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,sp,false,true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_SZONE,0,1,nil,e,tp) or Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp))
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE+LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function cm.gcheck(g)
	if g:FilterCount(Card.IsLocation,nil,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE)>0 then 
		return g:FilterCount(Card.IsLocation,nil,LOCATION_SZONE)<=0 and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE)<=1 
	end
	if g:FilterCount(Card.IsLocation,nil,LOCATION_SZONE)>0 then 
		return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE)<=0
	end
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_SZONE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter2),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local g=Group.__add(g1,g2)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,cm.gcheck,false,1,ct)
	Duel.SpecialSummon(sg,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
end
function cm.costfilter(c)
	return cm.God_Gold(c) and c:IsAbleToGraveAsCost()
end
function cm.GGcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.placefilter(c)
	return cm.God_Gold(c) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.placetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end
		return Duel.IsExistingMatchingCard(cm.placefilter,tp,LOCATION_DECK,0,1,nil) and ct>0
	end
end
function cm.placeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.placefilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
function cm.mvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL) and Duel.GetLocationCount(bc:GetOwner(),LOCATION_SZONE)>=1
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() and Duel.GetLocationCount(bc:GetOwner(),LOCATION_SZONE)>=1 and bc:IsType(TYPE_MONSTER) and not bc:IsImmuneToEffect(e)
		and Duel.MoveToField(bc,tp,bc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true)  then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		bc:RegisterEffect(e1)
	end
end
