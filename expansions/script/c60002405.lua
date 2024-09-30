--奇术尊者 米兰
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetRange(LOCATION_MZONE)
	--e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.bkop)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	--local tp=e:GetHandlerPlayer()
	Duel.RegisterFlagEffect(0,m,RESET_CHAIN,0,1)
end
function cm.filter(c,tp)
	local mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,TYPE_MONSTER)
	return c:IsSynchroSummonable(nil,mg)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local num=Duel.GetFlagEffect(0,m)
	local g=Duel.GetDecktopGroup(tp,num)
	--Debug.Message(tp)
	--Debug.Message(g:IsExists(Card.IsAbleToHand,1,nil))
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,tp) and g:GetCount()>=num and g:IsExists(Card.IsAbleToHand,1,nil) and Duel.GetMZoneCount(tp)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local num=Duel.GetFlagEffect(0,m)
	if Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.ConfirmDecktop(tp,num)
		local g=Duel.GetDecktopGroup(tp,num):Filter(Card.IsSetCard,nil,0xc620)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			if sg:GetFirst():IsAbleToHand() then
				if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
					Duel.ConfirmCards(1-tp,sg)
					Duel.ShuffleHand(tp)
					local ssg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil)
					local mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,TYPE_MONSTER)
					local spg=ssg:Select(tp,1,1,nil)
					if Duel.GetMZoneCount(tp,c)>0 then
						Duel.SynchroSummon(tp,spg:GetFirst(),nil,mg)
					end
				end
			else
				Duel.SendtoGrave(sg,REASON_RULE)
			end
			Duel.ShuffleDeck(tp)
		else
			Duel.ShuffleDeck(tp)
		end
	end
end
function cm.bkop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)
end