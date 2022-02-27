--动物朋友 桃红豹
local m=33701382
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x40)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,cm.lcheck)
	c:EnableReviveLimit()   
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	  --add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.condition)
	e2:SetOperation(cm.counter)
	c:RegisterEffect(e2)
-- 
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3) 
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x40,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x40,3,REASON_COST)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x442) 
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x442)
end
function cm.counter(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x40,1,true)
end
function cm.spfilter(c,e,tp,zone)
	local ok=false
	for p=0,1 do
		local zone=e:GetHandler():GetLinkedZone(p)&0xff
		ok=ok or (Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER))
	end
	return ok
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local zone={}
	local flag={}
	for p=0,1 do
		zone[p]=c:GetLinkedZone(p)&0xff
		local _,flag_tmp=Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[p])
		flag[p]=(~flag_tmp)&0x7f
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,flag)
	local sc=g:GetFirst()
	if sc then
		local ava_zone=0
		for p=0,1 do
			if sc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,p,zone[p]) then
				ava_zone=ava_zone|(flag[p]<<(p==tp and 0 or 16))
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local sel_zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0x00ff00ff&(~ava_zone))
		local sump=0
		if sel_zone&0xff>0 then
			sump=tp
		else
			sump=1-tp
			sel_zone=sel_zone>>16
		end
		Duel.SpecialSummon(sc,0,tp,sump,false,false,POS_FACEUP_DEFENSE,sel_zone)
	end
end