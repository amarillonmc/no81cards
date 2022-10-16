--五河琴里 指挥官
local m=33401011
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x341),2,99,cm.lcheck)
	c:EnableReviveLimit()
   --search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
--sps
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,1))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetCountLimit(1,m+20000)
	e8:SetTarget(cm.srtg)
	e8:SetOperation(cm.srop)
	c:RegisterEffect(e8)
end
function cm.lfilter(c)
	return c:IsSetCard(0x9341) and c:IsType(TYPE_FUSION) and c:IsType(TYPE_MONSTER) and c:GetOriginalAttribute()==ATTRIBUTE_FIRE
end
function cm.lcheck(g)
	return g:IsExists(cm.lfilter,1,nil)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thfilter(c)
	return  c:IsAbleToHand() and (c:IsSetCard(0x9341,0x5344) or (c:IsSetCard(0x46) and c:IsType(TYPE_SPELL)) ) 
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)   
	end 
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.splimit(e,c)
	return not c:IsSetCard(0x9341,0x5344) and c:IsLocation(LOCATION_EXTRA)
end

function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.spfilter(c,e,tp)
	return c:IsControler(tp) and  c:IsLocation(LOCATION_MZONE) and  c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FUSION) and  Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
end
function cm.spfilter2(c,e,tp,code)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FUSION) and c:IsSetCard(0x9341) 
 and c:IsLevelBelow(8)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and not c:IsCode(code)  
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return  eg:IsExists(cm.spfilter,1,nil,e,tp) end
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=eg:FilterSelect(tp,cm.spfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc:GetCode()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode())
		local tc2=g:GetFirst()
		tc2:SetMaterial(nil)
		local ss=Duel.SpecialSummon(tc2,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc2:CompleteProcedure()
		if ss~=0  then
		Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end

function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
and e:GetHandler():IsLocation(LOCATION_GRAVE)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	if c:IsRelateToEffect(e) and e:GetHandler():IsLocation(LOCATION_GRAVE)  then
		  if  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Damage(tp,1000,REASON_EFFECT)
			--must attack
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MUST_ATTACK)
		c:RegisterEffect(e1)
		end   
	end
end




