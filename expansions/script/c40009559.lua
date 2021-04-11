--顶峰天帝 巴斯提昂
function c40009559.initial_effect(c)
	c:SetUniqueOnField(1,0,40009559)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c40009559.spcon)
	e1:SetOperation(c40009559.spop)
	c:RegisterEffect(e1)  
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c40009559.indtg)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK,0)
	e2:SetValue(8)
	c:RegisterEffect(e2)  
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009559,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1)
	e3:SetCondition(c40009559.atkcon)
	e3:SetTarget(c40009559.atktg)
	e3:SetOperation(c40009559.atkop)
	c:RegisterEffect(e3)
end
function c40009559.rfilter(c,tp)
	return c:IsRace(RACE_WARRIOR) and (c:IsControler(tp) or c:IsFaceup())
end
function c40009559.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c40009559.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c40009559.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c40009559.mzfilter,ct,nil,tp))
end
function c40009559.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(c40009559.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,2,2,nil)
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c40009559.mzfilter,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c40009559.mzfilter,2,2,nil,tp)
	end
	Duel.Release(g,REASON_COST)
end
function c40009559.indtg(e,c)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	return  c:IsRace(RACE_WARRIOR) and c:IsLevelBelow(7) and (not c:IsLocation(LOCATION_DECK) or c:GetSequence()==dcount-1)
end
function c40009559.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and at:IsRace(RACE_WARRIOR)
end
function c40009559.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and tc:IsAbleToHand() end
end
function c40009559.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local at=Duel.GetAttacker()
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsLevelAbove(8) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		if at:IsFaceup() and at:IsRelateToBattle() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(2000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			at:RegisterEffect(e1)
		end
	else
		Duel.MoveSequence(tc,1)
	end
end

