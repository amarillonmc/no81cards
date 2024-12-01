--终焉的乐章 美树沙耶香
function c60152913.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_DEFENSE_ATTACK)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(c60152913.e1tg)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--damage conversion
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCode(EFFECT_REVERSE_DAMAGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(1,0)
	e8:SetValue(c60152913.rev)
	c:RegisterEffect(e8)
	
	--effect gain
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetCondition(c60152913.e3con)
	e9:SetOperation(c60152913.e3op)
	c:RegisterEffect(e9)

	if not c60152913.global_check then
		c60152913.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(c60152913.regop)
		Duel.RegisterEffect(ge1,0)

		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		ge2:SetOperation(c60152913.checkop2)
		Duel.RegisterEffect(ge1,0)
		local ge3=ge2:Clone()
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge4,0)

		local ge5=Effect.GlobalEffect()
		ge5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge5:SetCode(EVENT_BATTLE_CONFIRM)
		ge5:SetOperation(c60152913.checkop3)
		Duel.RegisterEffect(ge5,0)

		local ge6=Effect.GlobalEffect()
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge6:SetCode(EVENT_TO_GRAVE)
		ge6:SetOperation(c60152913.checkop4)
		Duel.RegisterEffect(ge6,0)
	end
	
	Duel.AddCustomActivityCounter(60152905,ACTIVITY_CHAIN,aux.FALSE)
	
end

function c60152913.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_DECK)
	local tc=g:GetFirst()
	while tc do
		if not (Duel.GetCurrentPhase()==PHASE_DRAW or Duel.GetCurrentPhase()==0) and Duel.GetFlagEffect(tc:GetControler(),60152901)==0 then
			Duel.RegisterFlagEffect(tc:GetControler(),60152901,RESET_PHASE+PHASE_END,0,1)
		end
		if Duel.GetFlagEffect(0,60152901)>0 and Duel.GetFlagEffect(1,60152901)>0 then
			break
		end
		tc=g:GetNext()
	end
end

function c60152913.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),60152902,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end


function c60152913.check(c)
	return c 
end
function c60152913.checkop3(e,tp,eg,ep,ev,re,r,rp)
	local c0,c1=Duel.GetBattleMonster(0)
	if c60152913.check(c0) then
		Duel.RegisterFlagEffect(0,60152903,RESET_PHASE+PHASE_END,0,1)
	end
	if c60152913.check(c1) then
		Duel.RegisterFlagEffect(1,60152903,RESET_PHASE+PHASE_END,0,1)
	end
end

function c60152913.checkop4(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local tc=g:GetFirst()
	while tc do
		if Duel.GetFlagEffect(tc:GetControler(),60152904)==0 then
			Duel.RegisterFlagEffect(tc:GetControler(),60152904,RESET_PHASE+PHASE_END,0,1)
		end
		if Duel.GetFlagEffect(0,60152904)>0 and Duel.GetFlagEffect(1,60152904)>0 then
			break
		end
		tc=g:GetNext()
	end
end

function c60152913.e1tg(e,c)
	return c:IsSetCard(0x3b29)
end
function c60152913.rev(e,re,r,rp,rc)
	return bit.band(r,REASON_EFFECT)>0
end
function c60152913.e3con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c60152913.e3op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if #g==0 then return end
	if g:IsExists(Card.IsOriginalCodeRule,1,nil,60152901) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(60152901,1))
		e1:SetCategory(CATEGORY_DAMAGE)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1,6012911)
		e1:SetCondition(c60152913.e22901con)
		e1:SetTarget(c60152913.e22901tg)
		e1:SetOperation(c60152913.e22901op)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60152913,1))
	end
	if g:IsExists(Card.IsOriginalCodeRule,1,nil,60152902) then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(60152902,1))
		e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DISABLE)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1,6012912)
		e2:SetCondition(c60152913.con)
		e2:SetTarget(c60152913.e22902tg)
		e2:SetOperation(c60152913.e22902op)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60152913,2))
	end
	if g:IsExists(Card.IsOriginalCodeRule,1,nil,60152903) then
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(60152903,1))
		e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_DEFCHANGE)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCountLimit(1,6012913)
		e3:SetCondition(c60152913.con)
		e3:SetTarget(c60152913.e22903tg)
		e3:SetOperation(c60152913.e22903op)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60152913,3))
	end
	if g:IsExists(Card.IsOriginalCodeRule,1,nil,60152904) then
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(60152904,1))
		e4:SetCategory(CATEGORY_DAMAGE)
		e4:SetType(EFFECT_TYPE_QUICK_O)
		e4:SetCode(EVENT_FREE_CHAIN)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCountLimit(1,6012914)
		e4:SetCondition(c60152913.e22904con)
		e4:SetTarget(c60152913.e22904tg)
		e4:SetOperation(c60152913.e22904op)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60152913,4))
	end
	if g:IsExists(Card.IsOriginalCodeRule,1,nil,60152905) then
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(60152905,1))
		e5:SetCategory(CATEGORY_NEGATE)
		e5:SetType(EFFECT_TYPE_QUICK_O)
		e5:SetCode(EVENT_CHAINING)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCountLimit(1,6012915)
		e5:SetCondition(c60152913.e22905con)
		e5:SetTarget(c60152913.e22905tg)
		e5:SetOperation(c60152913.e22905op)
		c:RegisterEffect(e5)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60152913,5))
	end
	if g:IsExists(Card.IsOriginalCodeRule,1,nil,60152906) then
		local e6=Effect.CreateEffect(c)
		e6:SetDescription(aux.Stringid(60152906,1))
		e6:SetCategory(CATEGORY_RECOVER)
		e6:SetType(EFFECT_TYPE_QUICK_O)
		e6:SetCode(EVENT_FREE_CHAIN)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCountLimit(1,6012916)
		e6:SetCondition(c60152913.con)
		e6:SetTarget(c60152913.e22906tg)
		e6:SetOperation(c60152913.e22906op)
		c:RegisterEffect(e6)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60152913,6))
	end
	if g:IsExists(Card.IsOriginalCodeRule,1,nil,60152907) then
		local e7=Effect.CreateEffect(c)
		e7:SetDescription(aux.Stringid(60152907,1))
		e7:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
		e7:SetType(EFFECT_TYPE_QUICK_O)
		e7:SetCode(EVENT_FREE_CHAIN)
		e7:SetRange(LOCATION_MZONE)
		e7:SetCountLimit(1,6012917)
		e7:SetCondition(c60152913.con)
		e7:SetTarget(c60152913.e22907tg)
		e7:SetOperation(c60152913.e22907op)
		c:RegisterEffect(e7)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60152913,7))
	end
end
function c60152913.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0
end
function c60152913.e22901con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,60152901)>0
end
function c60152913.e22901tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=PLAYER_ALL
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,1,nil) end
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,p,1000)
end
function c60152913.e22901opf(c)
	return c:IsAbleToDeck()
end
function c60152913.e22901op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if p==PLAYER_ALL then
		Duel.Damage(0,d,REASON_EFFECT,true)
		Duel.Damage(1,d,REASON_EFFECT,true)
		Duel.RDComplete()
		Duel.BreakEffect()
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 then
			Duel.ConfirmCards(tp,g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,c60152913.e22901opf,tp,0,LOCATION_HAND,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
			Duel.ShuffleHand(1-tp)
		end
	end
end
function c60152913.e22902opf(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c60152913.e22902tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=PLAYER_ALL
	if chk==0 then return Duel.GetFlagEffect(1-tp,60152902)>0 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,p,1000)
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tg,1,0,0)
end
function c60152913.e22902op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if p==PLAYER_ALL then
		Duel.Damage(0,d,REASON_EFFECT,true)
		Duel.Damage(1,d,REASON_EFFECT,true)
		Duel.RDComplete()
		Duel.BreakEffect()
		local c=e:GetHandler()
		local p1=Duel.GetLP(tp)
		local p2=Duel.GetLP(1-tp)
		local s=p2-p1
		if s<0 then s=p1-p2 end
		local d2=math.floor(s/1000)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c60152913.e22902opf,tp,0,LOCATION_ONFIELD,1,d2,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end
function c60152913.e22903tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=PLAYER_ALL
	if chk==0 then return Duel.GetFlagEffect(tp,60152903)>0 end
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,p,1000)
end
function c60152913.e22903op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if p==PLAYER_ALL then
		Duel.Damage(0,d,REASON_EFFECT,true)
		Duel.Damage(1,d,REASON_EFFECT,true)
		Duel.RDComplete()
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(tc:GetDefense()*2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e3:SetValue(1)
			tc:RegisterEffect(e3)
			tc=g:GetNext()
		end
	end
end
function c60152913.e22904con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,60152904)>0
end
function c60152913.e22904tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=PLAYER_ALL
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,p,1000)
end
function c60152913.e22904opf(c)
	return c:IsAbleToDeck()
end
function c60152913.e22904op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if p==PLAYER_ALL then
		Duel.Damage(0,d,REASON_EFFECT,true)
		Duel.Damage(1,d,REASON_EFFECT,true)
		Duel.RDComplete()
		Duel.BreakEffect()
		local c=e:GetHandler()
		local p1=Duel.GetLP(tp)
		local p2=Duel.GetLP(1-tp)
		local s=p2-p1
		if s<0 then s=p1-p2 end
		local d2=math.floor(s/1000)
		if d2>=1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,c60152913.e22904opf,tp,0,LOCATION_GRAVE,1,d2,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end
function c60152913.e22905con(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCustomActivityCount(60152905,1-tp,ACTIVITY_CHAIN)>0 and  Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0) then return end
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
			return true
		end
	end
	return false 
end
function c60152913.e22905tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=PLAYER_ALL
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
		end
	end
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(1000)
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
end
function c60152913.e22905op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if p==PLAYER_ALL then
		Duel.Damage(0,d,REASON_EFFECT,true)
		Duel.Damage(1,d,REASON_EFFECT,true)
		Duel.RDComplete()
		Duel.BreakEffect()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.NegateActivation(i) then
			local tc=te:GetHandler()
			if tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) then
				dg:AddCard(tc)
				end
			end
		end
	end
end
function c60152913.e22906tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c60152913.e22906op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	local c=e:GetHandler()
	local p1=Duel.GetLP(tp)
	local p2=Duel.GetLP(1-tp)
	local s=p2-p1
	if s<0 then s=p1-p2 end
	local d2=math.floor(s/1000)
	if d2>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,d2,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c60152913.e22907tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c60152913.e22907op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	--lose lp
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetOperation(c60152913.e22907oop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c60152913.e22907oop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60152913)
	Duel.Damage(tp,500,REASON_EFFECT,true)
	Duel.Damage(1-tp,500,REASON_EFFECT,true)
	Duel.RDComplete()
end