--何物为真
function c60010136.initial_effect(c)
	aux.AddCodeList(c,60010056,60010029)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c60010136.condition)
	e0:SetOperation(c60010136.activate)
	c:RegisterEffect(e0)
	--code
	local ge1=Effect.CreateEffect(c)
	ge1:SetDescription(aux.Stringid(60010136,0))
	ge1:SetCategory(CATEGORY_DRAW)
	ge1:SetType(EFFECT_TYPE_IGNITION)
	ge1:SetRange(LOCATION_MZONE)
	ge1:SetCountLimit(1)
	ge1:SetCost(c60010136.drcost)
	ge1:SetOperation(c60010136.drop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,60010056))
	e1:SetLabelObject(ge1)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,60010136)
	e2:SetCondition(c60010136.decon)
	e2:SetOperation(c60010136.deop)
	c:RegisterEffect(e2)
	--space check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(0xff)
	e3:SetCountLimit(1,60010129+EFFECT_COUNT_CODE_DUEL)
	e3:SetOperation(c60010136.checkop)
	c:RegisterEffect(e3)
end
function c60010136.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not SpaceCheck then
		SpaceCheck={}
		for i=0,1 do
			local g=Duel.GetMatchingGroup(nil,i,LOCATION_HAND+LOCATION_DECK,0,nil)
			if #g==g:GetClassCount(Card.GetCode) then
				SpaceCheck[i]=true
			end
		end
	end
end
function c60010136.condition(e,tp,eg,ep,ev,re,r,rp)
	return SpaceCheck[tp]
end
function c60010136.thfilter(c)
	return c:IsCode(60010056) and c:IsAbleToHand()
end
function c60010136.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010136.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60010136,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c60010136.tgfilter(c)
	return aux.IsCodeListed(c,60010029) and c:IsAbleToGraveAsCost() and c:IsFaceupEx()
end
function c60010136.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60010136.tgfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c60010136.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60010136.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c60010136.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	g:Merge(g2)
	Duel.SendtoGrave(g,REASON_COST)
end
function c60010136.drop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c60010136.draw)
	Duel.RegisterEffect(e1,tp)
end
function c60010136.draw(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60010136)
	if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
		local tg=Duel.GetOperatedGroup():Filter(Card.IsSSetable,nil)
		if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(60010136,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=tg:Select(tp,1,2,nil)
			Duel.SSet(tp,sg)
		end
	end
end
function c60010136.ownerfilter(c,tp)
	return c:IsCode(60010056) and c:IsFaceup() and c:IsSummonPlayer(tp)
end
function c60010136.decon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60010136.ownerfilter,1,nil,tp)
end
function c60010136.deop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c60010136.defcon)
	e1:SetOperation(c60010136.defop)
	Duel.RegisterEffect(e1,tp)
end
function c60010136.defcon(e,tp,eg,ep,ev,re,r,rp) 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return g:IsExists(Card.IsDefenseAbove,1,nil,1)
end
function c60010136.defop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):Filter(Card.IsDefenseAbove,1,nil,1)
	if #g>0 then
		Duel.Hint(HINT_CARD,0,60010136)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler()) 
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(-200)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)   
			tc:RegisterEffect(e1)
			if tc:GetDefense()==0 and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:GetBaseDefense()~=0 then
				Duel.Damage(tc:GetOwner(),tc:GetBaseDefense()/2,REASON_EFFECT,true)
			end
		end
		Duel.RDComplete()
	end 
end
