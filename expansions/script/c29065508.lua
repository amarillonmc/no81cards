--方 舟 骑 士 -陈
c29065508.named_with_Arknight=1
function c29065508.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3,c29065508.ovfilter,aux.Stringid(29065508,0),3,c29065508.xyzop)
	c:EnableReviveLimit()
	-- attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065508,4))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c29065508.btcost)
	e2:SetTarget(c29065508.bttg)
	e2:SetOperation(c29065508.btop)
	c:RegisterEffect(e2)
end
function c29065508.ovfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29065508.xyzop(e,tp,chk)
	if chk==0 then return (Duel.IsCanRemoveCounter(tp,1,0,0x10ae,2,REASON_COST) or (Duel.GetFlagEffect(tp,29096814)==1 and Duel.IsCanRemoveCounter(tp,1,0,0x10ae,1,REASON_COST))) and Duel.GetFlagEffect(tp,29065508)==0 end
	if Duel.GetFlagEffect(tp,29096814)==1 then
	Duel.ResetFlagEffect(tp,29096814)
	Duel.RemoveCounter(tp,1,0,0x10ae,1,REASON_RULE)
	Duel.RegisterFlagEffect(tp,29065508,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	else
	Duel.RemoveCounter(tp,1,0,0x10ae,2,REASON_RULE)
	Duel.RegisterFlagEffect(tp,29065508,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
end
function c29065508.btcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29065508.bttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c29065508.btop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tc=nil
		local tg=g:GetMinGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			tc=sg:GetFirst()
		else
			tc=tg:GetFirst()
		end
		if tc:IsType(TYPE_MONSTER) and tc:IsCanBeBattleTarget(c) and tc:IsControler(1-tp) and tc:IsLocation(LOCATION_MZONE) then
			Duel.CalculateDamage(c,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		e1:SetValue(c29065508.efilter)
		c:RegisterEffect(e1)
		end
	end
end
function c29065508.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end










