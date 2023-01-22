--好 奇 天 使 阿 撒 兹 勒
local m=22348147
local cm=_G["c"..m]
function cm.initial_effect(c)
	--翻 五 除 外
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,22348147)
	e1:SetTarget(c22348147.rmtg)
	e1:SetOperation(c22348147.rmop)
	c:RegisterEffect(e1)
	--特 殊 召 唤
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,22349147)
	e2:SetCondition(c22348147.spcon)
	e2:SetTarget(c22348147.sptg)
	e2:SetOperation(c22348147.spop)
	c:RegisterEffect(e2)
	c22348147.onfield_effect=e1
	c22348147.SetCard_diyuemo=true
	
end
function c22348147.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
function c22348147.rmfilter(c)
	return c:IsSetCard(0x45) and c:IsAbleToRemove()
end
function c22348147.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=2 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local tg=g:Filter(c22348147.rmfilter,nil)
	local ct1=tg:GetCount()
	if ct1>0 and Duel.SelectYesNo(tp,aux.Stringid(22348147,0)) then
		Duel.DisableShuffleCheck()
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
	Duel.ShuffleDeck(tp)
end
function c22348147.spfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsCode(22348143)
end
function c22348147.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348147.spfilter,1,nil,tp)
end
function c22348147.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22348147.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
