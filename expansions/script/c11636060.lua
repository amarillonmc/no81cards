--渊洋巨兽 锤头鲨母皇
local m=11636060
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x223),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),1)
	c:EnableReviveLimit()   
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1) 
	--tokon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.tkcon)
	e2:SetTarget(cm.tktg)
	e2:SetOperation(cm.tkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,m+2)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.tkcon2)
	e4:SetTarget(cm.tktg2)
	e4:SetOperation(cm.tkop2)
	c:RegisterEffect(e4)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x223) and c:IsControler(tp) 
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(cm.cfilter,1,nil,tp) and not eg:IsContains(c)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11636061,0x223,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,3,RACE_FISH,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,11636061,0x223,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,3,RACE_FISH,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,11636061)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
--
function cm.tkcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp)  and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.tktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local ct=math.min(ft1,ft2)
	if chk==0 then return ct>0 and (Duel.IsPlayerCanSpecialSummonMonster(tp,11636061,0x223,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,3,RACE_FISH,ATTRIBUTE_WATER) or Duel.IsPlayerCanSpecialSummonMonster(tp,11636061,0x223,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,3,RACE_FISH,ATTRIBUTE_WATER,1-tp) ) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft1+ft2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft1+ft2,0,0)
end
function cm.tkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft1<=0 and ft2<=0  then return end
	local ct=ft1+ft2
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		ct=1		
	end
	if not (Duel.IsPlayerCanSpecialSummonMonster(tp,11636061,0x223,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,3,RACE_FISH,ATTRIBUTE_WATER) and Duel.IsPlayerCanSpecialSummonMonster(tp,11636061,0x223,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,3,RACE_FISH,ATTRIBUTE_WATER,1-tp)) then return end
	if ct>0 then
		if ft1>0 then
			for i=1,ft1 do
				local token=Duel.CreateToken(tp,11636061)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)				
			end
		end
		if ft2>0 then
			for i=1,ft2 do
				local token=Duel.CreateToken(tp,11636061)
				Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)			
			end
		end
	end		 
	Duel.SpecialSummonComplete()
end