--电晶星的辉炮晶
function c72410130.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c72410130.lcheck)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,72410130)
	e1:SetCondition(c72410130.con)
	e1:SetTarget(c72410130.tg)
	e1:SetOperation(c72410130.operation)
	c:RegisterEffect(e1)
end
function c72410130.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x9729)
end
function c72410130.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetLinkedGroup()~=0
end
function c72410130.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroupCount()
	if chk==0 then return lg~=0 end
end
function c72410130.operation(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	local tg=Group.GetFirst(lg)
	while tg do
	if tg:GetFlagEffect(72410130)==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(72410130,0))
		e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(c72410130.thcon)
		e1:SetTarget(c72410130.thtg)
		e1:SetOperation(c72410130.thop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e1) 
		tg:RegisterFlagEffect(72410130,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(72410130,0))
		if not tg:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e3)
		end
	end
	tg=lg:GetNext()
	end
end

function c72410130.thcon(e)
	return (e:GetHandler():GetFlagEffect(72410132)==0 or (e:GetHandler():GetFlagEffect(72410132)==1 and e:GetHandler():GetFlagEffect(72410230)~=0))
end
function c72410130.filter(c)
	return c:IsSetCard(0x9729) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c72410130.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Card.RegisterFlagEffect(e:GetHandler(),72410132,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1,0) 
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c72410130.tgfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToGrave()
end
function c72410130.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.ShuffleHand(p)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(p,c72410130.tgfilter,p,LOCATION_HAND,0,1,1,nil)
	local tg=g:GetFirst()
	if tg then
		if Duel.SendtoGrave(g,REASON_EFFECT)==0 then
			Duel.ConfirmCards(1-p,tg)
			Duel.ShuffleHand(p)
		end
	else
		local sg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end