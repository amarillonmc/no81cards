--[[
本lua的作者为藜奴儿，如果测试出bug请联系QQ：1502939196

未经允许不支持任何人的任何形式的修改，源数。如有需要请联系作者，而不是私自找人代为修改。
本人对于本lua的任何bug修改、源数和适配后来卡片均为免费，并且追诉期无限。

但是如果使用者私自修改了lua，不论是bug修复还是源数效果，本人对此lua都不会再提供任何形式的支持。
一旦发现任何其他人对本lua进行了任何形式的修改，本人首先自愿放弃此lua除必要署名权以外的所有权利，
同时再也会不承担对此lua的任何维护与后续适配，包括但不限于任何形式的bug修复、效果源数。

如果您想要修改此lua，可以先联系本人，本人会在第一时间进行回复。
并且我承诺，若本人在2天内没有回复您，上述注意事项可作废，您可以直接修改此lua，而后续debug与适配仍然由我来进行。

如果您对本lua有任何疑问，请联系本人，本人会在第一时间进行回复。
如果您对本lua有任何建议，请联系本人，本人会在第一时间进行处理。
]]

--与魔鬼的契约
--aux.Stringid(id,0)="效果选择"
--aux.Stringid(id,1)="The Gathering"
--aux.Stringid(id,2)="No Glues"
--aux.Stringid(id,3)="Black sheep wall"
--aux.Stringid(id,4)="选择一张记载了此怪兽卡名的卡"
--aux.Stringid(id,5)="加入手卡"
--aux.Stringid(id,6)="盖放"

local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,36700304)
	--Activate only when you have 40+ "Fire's Dawn" cards
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	
	--Cannot be negated
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK)
	e2:SetValue(s.effectfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTarget(s.distg)
	c:RegisterEffect(e3)
end

function s.deckfilter(c)
	return c:IsSetCard(0xc50)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.deckfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_ONFIELD,0,nil)
	return ct>=40
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--Prevent losing duel if LP insufficient
	if Duel.GetLP(tp)<2000 then
		local ex1=Effect.CreateEffect(e:GetHandler())
		ex1:SetType(EFFECT_TYPE_FIELD)
		ex1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ex1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
		ex1:SetTargetRange(1,0)
		ex1:SetValue(1)
		ex1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(ex1,tp)
	end

	Duel.PayLPCost(tp,2000)
	
end

function s.effectfilter(e,ct)
	return Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT):GetHandler()==e:GetHandler()
end

function s.distg(e,c)
	return c==e:GetHandler()
end

function s.fdfilter(c,e,tp)
	return c:IsSetCard(0xc50) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.lmffilter(c)
	return c:IsCode(36700304)
end

function s.relfilter(c,code)
	return c.mention_code and c:IsAbleToHand() and c.mention_code[code]
end

function s.trapfilter(c)
	return c:IsType(TYPE_TRAP)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(s.fdfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
		local b2=true
		local b3=true
		return b1 or b2 or b3
	end
	
	local op=0
	if Duel.GetLP(tp)==0 then
		op=0
	else
		local b1=Duel.IsExistingMatchingCard(s.fdfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
		local b2=true
		local b3=true
		
		local ops={}
		local opval={}
		
		if b1 then
			table.insert(ops,aux.Stringid(id,1))
			table.insert(opval,1)
		end
		if b2 then
			table.insert(ops,aux.Stringid(id,2))
			table.insert(opval,2)
		end
		if b3 then
			table.insert(ops,aux.Stringid(id,3))
			table.insert(opval,3)
		end
		
		local sel=Duel.SelectOption(tp,table.unpack(ops))+1
		op=opval[sel]
	end
	
	e:SetLabel(op)
	
	if op==1 or op==0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
	end
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	
	-- Apply all effects if LP=0
	if op==0 then
		-- First effect: The Gathering
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.fdfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local tc=g:GetFirst()
			if s.lmffilter(tc) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4))
				local sg=Duel.SelectMatchingCard(tp,s.relfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc:GetCode())
				if #sg>0 then
					local sc=sg:GetFirst()
					local op2=Duel.SelectOption(tp,aux.Stringid(id,5),aux.Stringid(id,6))
					if op2==0 then
						Duel.SendtoHand(sc,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,sc)
					else
						Duel.SSet(tp,sc)
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
						e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						sc:RegisterEffect(e1)
						local e2=e1:Clone()
						e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
						sc:RegisterEffect(e2)
					end
				end
			end
		end
		
		-- Second effect: No Glues
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetTargetRange(0,LOCATION_MZONE)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetTargetRange(0,LOCATION_MZONE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_ACTIVATE)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetTargetRange(0,1)
		e5:SetValue(s.aclimit)
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
		
		-- Third effect: Black sheep wall
		local hg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_HAND,nil)
		local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_SZONE,nil)
		if #hg>0 then
			Duel.ConfirmCards(tp,hg)
		end
		if #sg>0 then
			Duel.ConfirmCards(tp,sg)
		end
		
		local trap_exist=Duel.IsExistingMatchingCard(s.trapfilter,tp,0,LOCATION_HAND+LOCATION_SZONE,1,nil)
		if trap_exist then
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_FIELD)
			e6:SetCode(EFFECT_CANNOT_ACTIVATE)
			e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e6:SetTargetRange(0,1)
			e6:SetValue(s.aclimit2)
			e6:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e6,tp)
		end
	
	-- Effect 1: The Gathering
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.fdfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local tc=g:GetFirst()
			if s.lmffilter(tc) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4))
				local sg=Duel.SelectMatchingCard(tp,s.relfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc:GetCode())
				if #sg>0 then
					local sc=sg:GetFirst()
					local op2=Duel.SelectOption(tp,aux.Stringid(id,5),aux.Stringid(id,6))
					if op2==0 then
						Duel.SendtoHand(sc,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,sc)
					else
						Duel.SSet(tp,sc)
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
						e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						sc:RegisterEffect(e1)
						local e2=e1:Clone()
						e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
						sc:RegisterEffect(e2)
					end
				end
			end
		end
	
	-- Effect 2: No Glues
	elseif op==2 then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetTargetRange(0,LOCATION_MZONE)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetTargetRange(0,LOCATION_MZONE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_ACTIVATE)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetTargetRange(0,1)
		e5:SetValue(s.aclimit)
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
	
	-- Effect 3: Black sheep wall
	elseif op==3 then
		local hg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_HAND,nil)
		local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_SZONE,nil)
		if #hg>0 then
			Duel.ConfirmCards(tp,hg)
		end
		if #sg>0 then
			Duel.ConfirmCards(tp,sg)
		end
		
		local trap_exist=Duel.IsExistingMatchingCard(s.trapfilter,tp,0,LOCATION_HAND+LOCATION_SZONE,1,nil)
		if trap_exist then
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_FIELD)
			e6:SetCode(EFFECT_CANNOT_ACTIVATE)
			e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e6:SetTargetRange(0,1)
			e6:SetValue(s.aclimit2)
			e6:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e6,tp)
		end
	end

	-- Skip to next opponent's battle phase
	if Duel.GetTurnPlayer()==tp then
		-- End current player's turn
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_SKIP_TURN)
		e3:SetTargetRange(1,0)
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		Duel.RegisterEffect(e3,tp)

		-- Skip to opponent's battle phase next turn
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetCode(EFFECT_SKIP_M1)
		e4:SetTargetRange(0,1)
		e4:SetReset(RESET_PHASE+PHASE_BATTLE_START+RESET_OPPO_TURN)
		Duel.RegisterEffect(e4,tp)
	else
		-- Skip to battle phase if not first turn
		if Duel.GetTurnCount()>1 then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_SKIP_M1)
			e3:SetTargetRange(0,1)
			e3:SetReset(RESET_PHASE+PHASE_BATTLE_START+RESET_OPPO_TURN)
			Duel.RegisterEffect(e3,tp)
		end
	end

	-- Force all monsters to attack if possible
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_MUST_ATTACK)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
end

function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOnField()
end

function s.aclimit2(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end