--特米米·珊瑚海岸收藏-静谧午夜
function c79029909.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(79029313)
	c:RegisterEffect(e0)   
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029909.splimit1)
	c:RegisterEffect(e2)  
	--pos sp 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,79029909)
	e1:SetTarget(c79029909.pstg)
	e1:SetOperation(c79029909.psop)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029909,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,09029909)
	e2:SetTarget(c79029909.fltg)
	e2:SetOperation(c79029909.flop)
	c:RegisterEffect(e2)
	--to hand 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,19029909)
	e3:SetCost(c79029909.thcost)
	e3:SetTarget(c79029909.thtg)
	e3:SetOperation(c79029909.thop)
	c:RegisterEffect(e3)
end
function c79029909.splimit1(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029909.pstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local tc=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_PZONE)
end
function c79029909.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then 
	Debug.Message("等一下，我还没准备好！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029909,1))
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then 
	Duel.BreakEffect()
	Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029909.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c79029909.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xa900) and c:IsLocation(LOCATION_EXTRA)
end
function c79029909.thfil(c)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c79029909.stfil(c,lsc)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_PENDULUM) and c:GetLeftScale()~=lsc 
end
function c79029909.fltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029909.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029909.flop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029909.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Debug.Message("还，还是上战场直接操练一下比较好，对吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029909,2))
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	local lsc=tc:GetLeftScale()
	if tc:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(c79029909.stfil,tp,LOCATION_DECK,0,1,nil,lsc) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.CheckLPCost(tp,1500) and Duel.SelectYesNo(tp,aux.Stringid(79029909,0)) then 
	Debug.Message("上，上了！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029909,3))
	Duel.PayLPCost(tp,1500)
	local tc1=Duel.SelectMatchingCard(tp,c79029909.stfil,tp,LOCATION_DECK,0,1,1,nil,lsc):GetFirst()
	Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c79029909.ctfil(c)
	return c:IsAbleToExtra() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa900) 
end
function c79029909.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029909.ctfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end 
	local g=Duel.SelectMatchingCard(tp,c79029909.ctfil,tp,LOCATION_ONFIELD,0,1,99,e:GetHandler())
	Duel.SendtoExtraP(g,nil,REASON_COST)
end
function c79029909.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c79029909.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
	Debug.Message("让我学学看您的技巧，要是真能学会就好了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029909,4))
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end






