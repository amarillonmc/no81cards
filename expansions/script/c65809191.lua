--策略 人口贩卖
Duel.LoadScript("STATS_CHANGED.lua")
if not PROC_STATS_CHANGED then
	PROC_STATS_CHANGED=true
	UnofficialProc.statsChanged()
end
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(511009110)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCondition(s.thcon2)
	e3:SetTarget(s.thtg2)
	e3:SetOperation(s.thop2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function s.cfilter(c,tp)
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	return c:IsControler(tp) and c:GetAttack()~=val and c:IsOnField() and c:IsFaceup()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0xca30) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)
end
function s.thfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand(tp)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local sp=false
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		local mg=g:Filter(s.thfilter,nil,tp)
		if #mg==0 then return end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=mg:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg,tp,REASON_EFFECT)~=0 then sp=true end
	end
	if sp and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end