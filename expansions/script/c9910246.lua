--星幽蜜友 壬生千咲
function c9910246.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--change scale
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9910246)
	e1:SetTarget(c9910246.sctg)
	e1:SetOperation(c9910246.scop)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c9910246.sprcon)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,9910247)
	e3:SetTarget(c9910246.drtg)
	e3:SetOperation(c9910246.drop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetLabelObject(e3)
	e4:SetOperation(c9910246.chk)
	c:RegisterEffect(e4)
end
function c9910246.scfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x957)
end
function c9910246.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910246.scfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c9910246.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910246,0))
	local g=Duel.SelectMatchingCard(tp,c9910246.scfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc or Duel.SendtoExtraP(tc,nil,REASON_EFFECT)==0 then return end
	local lv=tc:GetLevel()
	local sel=0
	if c:GetLeftScale()==0 then
		sel=Duel.SelectOption(tp,aux.Stringid(9910246,1))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(9910246,1),aux.Stringid(9910246,2))
	end
	if sel==1 then
		lv=-math.min(lv,c:GetLeftScale())
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(lv)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
end
function c9910246.cfilter(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsType(TYPE_PENDULUM))
end
function c9910246.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return not Duel.IsExistingMatchingCard(c9910246.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c9910246.chk(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLinkState() then e:GetLabelObject():SetLabel(1)
	else e:GetLabelObject():SetLabel(0) end
end
function c9910246.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	if e:GetHandler():IsPreviousLocation(LOCATION_MZONE) and e:GetLabel()==1 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
	else
		e:SetCategory(CATEGORY_DRAW)
		e:SetLabel(0)
	end
end
function c9910246.thfilter(c,type1)
	return not c:IsType(type1) and c:IsSetCard(0x957) and c:IsAbleToHand()
end
function c9910246.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		local type1=tc:GetType()&0x7
		local sg=Duel.GetMatchingGroup(c9910246.thfilter,p,LOCATION_DECK,0,nil,type1)
		if e:GetLabel()==1 and #sg>0 and Duel.SelectYesNo(p,aux.Stringid(9910246,3)) then
			Duel.BreakEffect()
			Duel.ConfirmCards(1-p,tc)
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
			local hg=sg:Select(p,1,1,nil)
			if #hg>0 then
				Duel.SendtoHand(hg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-p,hg)
			end
		end
		Duel.ShuffleHand(p)
	end
end
