--真理的继承者 蓓哈丽娅
function c11771317.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11771317.filter0,2)
	-- 战吼抽卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11771317,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11771317)
	e1:SetTarget(c11771317.tg1)
	e1:SetOperation(c11771317.op1)
	c:RegisterEffect(e1)
	-- 骰子效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11771317,1))
	e2:SetCategory(CATEGORY_DICE+CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11771318)
	e2:SetTarget(c11771317.tg2)
	e2:SetOperation(c11771317.op2)
	c:RegisterEffect(e2)
end
-- link
function c11771317.filter0(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE))
end
-- 1
function c11771317.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11771317.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
-- 2
function c11771317.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c11771317.op2(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	if d==1 or d==3 then
		if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_TOSS_DICE_NEGATE)
			e1:SetCondition(c11771317.coincon)
			e1:SetOperation(c11771317.coinop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			e1:SetLabel(0)
		end
	elseif d==2 or d==4 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),tp,LOCATION_GRAVE,0,nil,e,0,tp,false,false)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			if #sg>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				local tc=sg:GetFirst()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
	elseif d==5 or d==6 then
		local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(function(c) return c:IsEffectProperty(aux.MonsterEffectPropertyFilter(EFFECT_FLAG_DICE)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end),tp,LOCATION_GRAVE,0,nil)
		local g2=Duel.GetMatchingGroup(function(c) return c:IsEffectProperty(aux.MonsterEffectPropertyFilter(EFFECT_FLAG_DICE)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end,tp,LOCATION_REMOVED,0,nil)
		g1:Merge(g2)
		if #g1>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g1:Select(tp,1,1,nil)
			if #sg>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c11771317.coincon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabel()<1
end
function c11771317.coinop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabel()<1 and Duel.SelectYesNo(tp,aux.Stringid(11771317,2)) then
        Duel.Hint(HINT_CARD,0,11771317)
        e:SetLabel(1)
        local dc={Duel.GetDiceResult()}
        local ac=1
        local ct=(ev&0xff)+(ev>>16&0xff)
        if ct>1 then
            Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11771317,3))
            local val,idx=Duel.AnnounceNumber(tp,table.unpack(aux.idx_table,1,ct))
            ac=idx+1
        end
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11771317,4))
        dc[ac]=Duel.TossDice(tp,1)
        Duel.SetDiceResult(table.unpack(dc))
    end
end
