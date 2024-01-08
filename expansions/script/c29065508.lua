--方舟骑士-陈
c29065508.named_with_Arknight=1
function c29065508.initial_effect(c)
	aux.AddCodeList(c,29065500) 
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c29065508.mfilter,aux.TRUE,2,2)
--,c29065508.ovfilter,aux.Stringid(29065510,0),c29065508.xyzop)
	c:EnableReviveLimit()
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065508,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c29065508.btcost)
	e2:SetTarget(c29065508.bttg)
	e2:SetOperation(c29065508.btop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29065508,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,29065508)
	e3:SetCondition(c29065508.secon)
	e3:SetTarget(c29065508.settg)
	e3:SetOperation(c29065508.setop)
	c:RegisterEffect(e3)
end
function c29065508.ovfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29065508.cfilter(c)
	return c:IsDiscardable()
end
function c29065508.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065508.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerAffectedByEffect(tp,29065510) and Duel.GetFlagEffect(tp,29065511)==0 end
	Duel.DiscardHand(tp,c29065508.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
	Duel.RegisterFlagEffect(tp,29065511,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c29065508.ffilter(c,chk)
	return c:IsCode(29065500) and c:IsFaceup()
end
function c29065508.secon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c29065508.ffilter,tp,LOCATION_MZONE,0,1,nil,true)
end
function c29065508.filter(c,chk)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_TRAP) and c:IsSSetable(chk)
end
function c29065508.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065508.filter,tp,LOCATION_DECK,0,1,nil,true) end
end
function c29065508.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c29065508.filter,tp,LOCATION_DECK,0,1,1,nil,false)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c29065508.mfilter(c,xyzc)
	local b1=(c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
	local b2=c:IsXyzLevel(xyzc,5)
	local b3=c:IsXyzLevel(xyzc,6)
	return b1 and (b2 or b3)
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
		end
	end
end
function c29065508.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end










