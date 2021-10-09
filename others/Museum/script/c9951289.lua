--fate·狂战组
function c9951289.initial_effect(c)
	 --synchro summon
	aux.AddSynchroMixProcedure(c,c9951289.matfilter1,nil,nil,aux.NonTuner(Card.IsType,TYPE_SYNCHRO),1,99)
	c:EnableReviveLimit()
--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c9951289.efilter)
	c:RegisterEffect(e3)
 --salvage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9951289,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCondition(c9951289.thcon)
	e5:SetTarget(c9951289.thtg)
	e5:SetOperation(c9951289.thop)
	c:RegisterEffect(e5)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c9951289.valcheck)
	e0:SetLabelObject(e5)
	c:RegisterEffect(e0)
  --draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951289,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9951289)
	e3:SetCondition(c9951289.drcon)
	e3:SetTarget(c9951289.drtg)
	e3:SetOperation(c9951289.drop)
	c:RegisterEffect(e3)
	--remove,lvup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951289,3))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,99512890)
	e4:SetTarget(c9951289.rmtg)
	e4:SetOperation(c9951289.rmop)
	c:RegisterEffect(e4)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951289.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951289.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951289,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9951289,4))
end
function c9951289.matfilter1(c)
	return (c:IsType(TYPE_TUNER) or (c:IsType(TYPE_SYNCHRO) and c:IsSummonType(SUMMON_TYPE_SYNCHRO))) and c:IsSetCard(0xba5)
end
function c9951289.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9951289.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function c9951289.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9951289.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c9951289.mfilter(c)
	return c:IsSetCard(0xba5) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9951289.valcheck(e,c)
	local g=c:GetMaterial()
	local tg=g:Filter(c9951289.mfilter,nil)
	for tc in aux.Next(tg) do
		g:RemoveCard(tc)
		local flag=g:FilterCount(aux.NonTuner(Card.IsType,TYPE_SYNCHRO),nil,c)==g:GetCount()
		g:AddCard(tc)
		if flag then
			e:GetLabelObject():SetLabel(1)
			return
		end
	end
	e:GetLabelObject():SetLabel(0)
end
function c9951289.drcfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function c9951289.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9951289.drcfilter,1,nil,tp)
end
function c9951289.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9951289.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c9951289.tgfilter(c,tp)
	return c:IsSetCard(0xba5) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c9951289.rmfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,c)
end
function c9951289.rmfilter(c)
	return (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup()) and c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c9951289.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9951289.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9951289.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9951289.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE)
end
function c9951289.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ec=nil
	if tc:IsRelateToEffect(e) then
		ec=tc
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9951289.rmfilter),tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,99,ec,tp)
	if rg:GetCount()>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local atk=og:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(atk*1000)
			tc:RegisterEffect(e1)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951289,0))
end
