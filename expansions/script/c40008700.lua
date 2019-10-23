--炼狱骑士团 死神镰刀龙 
if not pcall(function() require("expansions/script/c40008677") end) then require("script/c40008677") end
function c40008700.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008700,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,40008700)
	e1:SetCondition(c40008700.thcon)
	e1:SetTarget(c40008700.rmtg)
	e1:SetOperation(c40008700.rmop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c40008700.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2) 
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008700,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,40008701)
	e3:SetCost(rsik.cost())
	e3:SetTarget(c40008700.target)
	e3:SetOperation(c40008700.activate)
	c:RegisterEffect(e3)	 
end
function c40008700.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_NORMAL) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c40008700.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c40008700.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c40008700.afilter(c)
	return c:IsType(TYPE_MONSTER) 
end
function c40008700.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local tg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
		if tg:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=tg:Select(tp,1,1,nil)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
end
end
end
function c40008700.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g1=Duel.GetDecktopGroup(tp,1)
		local tc1=g1:GetFirst()
		local g2=Duel.GetDecktopGroup(1-tp,1)
		local tc2=g2:GetFirst()
		return tc1 and tc2 and tc1:IsAbleToGrave() and tc2:IsAbleToGrave() and tc1:IsAbleToHand() and tc2:IsAbleToHand()
	end
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1000)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c40008700.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	Duel.ConfirmDecktop(1-tp,1)
	local g1=Duel.GetDecktopGroup(tp,1)
	local tc1=g1:GetFirst()
	local g2=Duel.GetDecktopGroup(1-tp,1)
	local tc2=g2:GetFirst()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if bit.band(tc1:GetType(),0x7)==bit.band(tc2:GetType(),0x7) then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc1,nil,REASON_EFFECT)
		Duel.SendtoHand(tc2,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
	else
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tc1,POS_FACEUP,REASON_EFFECT)
		Duel.SendtoGrave(tc2,POS_FACEUP,REASON_EFFECT)
		Duel.Damage(p,d,REASON_EFFECT)
	end
end