--萨尔贡·重装干员-暴雨
function c79029462.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa900),aux.NonTuner(nil),1)
	c:EnableReviveLimit()   
	--sp or th 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029462)
	e1:SetTarget(c79029462.sttg)
	e1:SetOperation(c79029462.stop)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029462,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,09029462)
	e2:SetCost(c79029462.rccost)
	e2:SetTarget(c79029462.rctg)
	e2:SetOperation(c79029462.rcop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029462,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,19029462)
	e3:SetCost(c79029462.spcost)
	e3:SetTarget(c79029462.sptg)
	e3:SetOperation(c79029462.spop)
	c:RegisterEffect(e3)
end
function c79029462.ckfil(c,e,tp)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_PENDULUM) and (c:IsAbleToHand() or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not c:IsLocation(LOCATION_EXTRA)) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))))
end
function c79029462.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029462.ckfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)  
end
function c79029462.stop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("准备接敌！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029462,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c79029462.ckfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_EXTRA) then 
	ft=Duel.GetLocationCountFromEx(tp,tp,nil,tc)	
	else
	ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	end
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c79029462.ctfil(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xa900)
end
function c79029462.rccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029462.ctfil,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029462.ctfil,tp,LOCATION_MZONE,0,1,99,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_TEMPORARY)
	e:SetLabel(g:GetCount())
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(g)
		e1:SetCountLimit(1)
		e1:SetOperation(c79029462.retop)
		Duel.RegisterEffect(e1,tp)  
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(HALF_DAMAGE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c79029462.retop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("这里就好。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029462,4))
	local g=e:GetLabelObject()
	local tc=g:GetFirst()
	while tc do
	Duel.ReturnToField(tc)
	tc=g:GetNext()
	end
end
function c79029462.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,0)
end
function c79029462.rcop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("......我会尽力。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029462,3))
	local x=e:GetLabel()
	Duel.Recover(tp,x*1500,REASON_EFFECT)
end
function c79029462.excfil(c)
	return c:IsAbleToGraveAsCost() and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa900)
end
function c79029462.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029462.excfil,tp,LOCATION_EXTRA,0,2,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029462.excfil,tp,LOCATION_EXTRA,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029462.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c79029462.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
	Debug.Message("博士，我还能战斗。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029462,5))
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end







