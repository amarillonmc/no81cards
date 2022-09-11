--地 壳 下 的 嫉 妒 心  帕 露 西
local m=22348271
local cm=_G["c"..m]
function cm.initial_effect(c) 
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--移 动 位 置
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348271,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22348271)
	e1:SetTarget(c22348271.movtg)
	e1:SetOperation(c22348271.movop)
	c:RegisterEffect(e1)
	--战 破 抗 性
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c22348271.tglimit)
	c:RegisterEffect(e2)
	--draw

--  e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348271,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22348272)
	e3:SetCondition(c22348271.drcon)
	e3:SetTarget(c22348271.drtg)
	e3:SetOperation(c22348271.drop)
	c:RegisterEffect(e3)

end

function c22348271.movtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function c22348271.movop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	Duel.MoveSequence(c,seq) 
	local ag=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local bg=Group.__sub(ag,c:GetColumnGroup())
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,bg)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22348271,0)) then
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		if tc then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
		end
	end

end

function c22348271.tglimit(e,c)
	return c and not c:GetBattleTarget():GetColumnGroup():IsContains(c)
end


function c22348271.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetHandler()
	local bc=re:GetHandler()
	local seq1=ac:GetSequence()
	local seq2=bc:GetSequence()
	if seq1==0 and seq2==1 then
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
	elseif seq1==1 then
			if seq2==0 then
			return re:IsHasType(EFFECT_TYPE_ACTIVATE)
			elseif seq2==2 then
			return re:IsHasType(EFFECT_TYPE_ACTIVATE)
			end
	elseif seq1==2 then
			if seq2==1 then
			return re:IsHasType(EFFECT_TYPE_ACTIVATE)
			elseif seq2==3 then
			return re:IsHasType(EFFECT_TYPE_ACTIVATE)
			end
	elseif seq1==3 then
			if seq2==2 then
			return re:IsHasType(EFFECT_TYPE_ACTIVATE)
			elseif seq2==4 then
			return re:IsHasType(EFFECT_TYPE_ACTIVATE)
			end
	elseif seq1==4 and seq2==3 then
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
	end
end

function c22348271.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c22348271.drop(e,tp,eg,ep,ev,re,r,rp)
	local aaa=Duel.TossDice(tp,1)
	if aaa==1 then
		local g1=Duel.CreateToken(tp,22348272)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
	elseif aaa==2 then
		local g1=Duel.CreateToken(tp,22348273)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
	elseif aaa==3 then
		local g1=Duel.CreateToken(tp,22348275)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
	elseif aaa==4 then
		local g1=Duel.CreateToken(tp,22348277)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
	elseif aaa==5 then
		local g1=Duel.CreateToken(tp,22348278)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
	elseif aaa==6 then
		local g1=Duel.CreateToken(tp,22348279)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
	end
end


function c22348271.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end






