--前线阵地 水晶惑星
local m=13257215
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.etarget)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--roll and destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(cm.rdtg)
	e3:SetOperation(cm.rdop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(cm.spcon)
	e4:SetCost(cm.spcost)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,4))
end
function cm.etarget(e,c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function cm.efilter(e,re)
	return re:GetHandler()==e:GetHandler()
end
function cm.rdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(eg:GetFirst():GetSummonPlayer())
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,eg:GetFirst():GetSummonPlayer(),1)
end
function cm.desfilter(c)
	return c:GetSequence()>4
end
function cm.rdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d1=Duel.TossDice(p,1)
	if d1<6 then
		local tc=Duel.GetFieldCard(p,LOCATION_MZONE,d1-1)
		if tc then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	elseif d1==6 then
		local tc=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsCode(13257214) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetTurnPlayer()~=tp
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,5))
	end
end
