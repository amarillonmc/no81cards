--绮奏降律·断序圣仪
function c66620610.initial_effect(c)

    -- 作为这张卡的发动时的效果处理，可以从自己的手卡·墓地选1只7星以下的机械族怪兽特殊召唤，这个回合，自己不是机械族怪兽不能特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,66620610+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c66620610.activate)
	c:RegisterEffect(e1)
	
	-- 每次自己把「绮奏」速攻魔法卡的效果发动，对方场上的全部怪兽的攻击力·守备力下降600
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c66620610.regop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetCondition(c66620610.atkcon)
	e5:SetOperation(c66620610.atkop)
	c:RegisterEffect(e5)
	
	-- 只要这张卡在魔法与陷阱区域存在，对方不能把攻击力0的怪兽的效果发动
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(0,1)
	e6:SetValue(c66620610.aclimit)
	c:RegisterEffect(e6)
end

-- 作为这张卡的发动时的效果处理，可以从自己的手卡·墓地选1只7星以下的机械族怪兽特殊召唤，这个回合，自己不是机械族怪兽不能特殊召唤
function c66620610.setcardfilter(c,e,tp)
	return c:IsLevelBelow(7) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c66620610.activate(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(aux.NecroValleyFilter(function(c)
	    return c66620610.setcardfilter(c,e,tp)
    end),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	if #cg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(66620610,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=cg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c66620610.splimit2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c66620610.splimit2(e,c)
	return not c:IsRace(RACE_MACHINE)
end

-- 每次自己把「绮奏」速攻魔法卡的效果发动，对方场上的全部怪兽的攻击力·守备力下降600
function c66620610.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(66620610,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end

function c66620610.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==tp and re:IsActiveType(TYPE_QUICKPLAY) and re:GetHandler():IsSetCard(0x666a) and c:GetFlagEffect(66620610)~=0
end

function c66620610.atkfilter(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e)
end

function c66620610.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c66620610.atkfilter,tp,0,LOCATION_MZONE,nil,e)
	if g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,66620610)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-600)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
	        e2:SetCode(EFFECT_UPDATE_DEFENSE)
	        tc:RegisterEffect(e2)
		end
	end
end

-- 只要这张卡在魔法与陷阱区域存在，对方不能把攻击力0的怪兽的效果发动
function c66620610.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttack(0)
end
