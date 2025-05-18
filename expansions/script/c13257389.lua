--梦超时空战斗机-姬海棠 果
local s,id,o=GetID()
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function s.initial_effect(c)
	c:EnableCounterPermit(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB)
	c:SetCounterLimit(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetOperation(s.atop)
	c:RegisterEffect(e0)
	
end
function s.spfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x351) and c:IsAbleToHandAsCost()
		and Duel.GetMZoneCount(tp,c)>0
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoHand(g,nil,REASON_SPSUMMON)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function s.eqfilter(c,ec)
	return c:IsSetCard(0x6352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsCanAddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1) then
		e:GetHandler():AddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1)
	end
end
