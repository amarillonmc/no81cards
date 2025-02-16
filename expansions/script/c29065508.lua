--方舟骑士-陈
function c29065508.initial_effect(c)
	aux.AddCodeList(c,29065500) 
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	--aux.AddXyzProcedureLevelFree(c,c29065508.mfilter,aux.TRUE,2,2)
	--aux.AddXyzProcedure(c,nil,6,2,c29065508.ovfilter,aux.Stringid(29065508,2),2,c29065508.xyzop)
	c:EnableReviveLimit()
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065508,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,29065509)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c29065508.btcost)
	e2:SetTarget(c29065508.bttg)
	e2:SetOperation(c29065508.btop)
	c:RegisterEffect(e2)
	--set
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(29065508,0))
	--e3:SetType(EFFECT_TYPE_IGNITION)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1,29065508)
	--e3:SetCondition(c29065508.secon)
	--e3:SetTarget(c29065508.settg)
	--e3:SetOperation(c29065508.setop)
	--c:RegisterEffect(e3)
	--immune
	--local e4=Effect.CreateEffect(c)
	--e4:SetType(EFFECT_TYPE_SINGLE)
	--e4:SetCode(EFFECT_IMMUNE_EFFECT)
	--e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e4:SetRange(LOCATION_MZONE)
	--e4:SetCondition(c29065508.imcon)
	--e4:SetValue(c29065508.efilter)
	--c:RegisterEffect(e4)
	--indes
	--local e5=Effect.CreateEffect(c)
	--e5:SetType(EFFECT_TYPE_SINGLE)
	--e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e5:SetRange(LOCATION_MZONE)
	--e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	--e5:SetCondition(c29065508.imcon)
	--e5:SetValue(1)
	--c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(29065508,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,29065508)
	e6:SetTarget(c29065508.thtg)
	e6:SetOperation(c29065508.thop)
	c:RegisterEffect(e6)
end
function c29065508.thfilter(c)
	return c:IsSetCard(0x87af) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c29065508.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065508.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29065508.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29065508.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c29065508.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x87af)
end
function c29065508.cdfilter(c)
	return c:IsCode(29065510) and c:IsFaceup()
end
function c29065508.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(c29065508.cdfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c29065508.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(id)==1
end
function c29065508.ffilter(c,chk)
	return c:IsCode(29065500) and c:IsFaceup()
end
function c29065508.secon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c29065508.ffilter,tp,LOCATION_MZONE,0,1,nil,true)
end
function c29065508.filter(c,chk)
	return c:IsSetCard(0x87af) and c:IsType(TYPE_TRAP) and c:IsSSetable(chk)
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
	local b1=c:IsSetCard(0x87af) 
	local b2=c:IsXyzLevel(xyzc,5)
	local b3=c:IsXyzLevel(xyzc,6)
	return b1 and (b2 or b3)
end
function c29065508.btcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29065508.bttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	--c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function c29065508.btop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	   -- local tc=nil
	   -- local tg=g:GetMinGroup(Card.GetAttack)
	   -- if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			tc=sg:GetFirst()
		--else
		--	tc=tg:GetFirst()
		--end
		if tc:IsType(TYPE_MONSTER) and tc:IsCanBeBattleTarget(c) and tc:IsControler(1-tp) and tc:IsLocation(LOCATION_MZONE) then
			Duel.CalculateDamage(c,tc)
		end
	end
end
function c29065508.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end










