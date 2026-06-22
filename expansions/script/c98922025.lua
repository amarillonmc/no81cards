--剑斗兽 图里努斯
--剑斗兽 图里努斯
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(s.matfilter1),aux.FilterBoolFunction(Card.IsFusionSetCard,0x1019),3,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.SendtoDeck,nil,2,REASON_COST)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
	--search & spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.cbcon)
	e3:SetCost(s.cbcost)
	e3:SetTarget(s.cbtg)
	e3:SetOperation(s.cbop)
	c:RegisterEffect(e3)
end
function s.matfilter1(c)
	return c:IsFusionSetCard(0x1019) and c:IsLevelAbove(7)
end
function s.spfilter1(c,tp,fc)
	return c:IsFusionSetCard(0x1019) and c:IsLevelAbove(7) and c:IsAbleToDeckAsCost() and c:IsCanBeFusionMaterial(fc)
end
function s.spfilter2(c,tp,fc)
	return c:IsFusionSetCard(0x1019) and c:IsAbleToDeckAsCost() and c:IsCanBeFusionMaterial(fc)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	local typ=re:GetActiveType()
	local flag=0
	if typ&TYPE_MONSTER~=0 then flag=id+TYPE_MONSTER
	elseif typ&TYPE_SPELL~=0 then flag=id+TYPE_SPELL
	elseif typ&TYPE_TRAP~=0 then flag=id+TYPE_TRAP
	end
	e:SetLabel(flag)
	return flag~=0 and e:GetHandler():GetFlagEffect(flag)==0
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local flag=e:GetLabel()
	e:GetHandler():RegisterFlagEffect(flag,RESET_EVENT+RESETS_STANDARD,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.cbcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function s.cbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function s.cbfilter(c,e,tp)
	if not c:IsSetCard(0x1019) then return false end
	if c:IsType(TYPE_MONSTER) then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	else
		return c:IsAbleToHand()
	end
end
function s.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local g=Duel.GetMatchingGroup(s.cbfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if ft<=0 then g=g:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP) end
		return g:GetCount()>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function s.cbop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(s.cbfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local tg=Group.CreateGroup()
	if #g>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		if ft<=0 then
			-- 没有格子只能选魔陷
			local stg=g:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
			if #stg>=3 then
				tg=stg:Select(tp,3,3,nil)
			end
		else
			-- 如果选了太多怪兽导致超过可用格子，需要在选择前做限制，这里简化为如果有足够卡即可
			-- 最多只能选ft只怪兽
			tg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		end
		if tg and #tg==3 then
			local mg=tg:Filter(Card.IsType,nil,TYPE_MONSTER)
			local sg=tg:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
			if #mg>0 then
				Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
			end
			if #sg>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end