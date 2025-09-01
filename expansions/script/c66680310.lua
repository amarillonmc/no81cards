--堕福的圣曲・风花梦
local s,id,o=GetID()
function s.initial_effect(c)

    -- ●丢弃1张手卡才能发动，从卡组把2只「堕福」怪兽加入手卡（同名卡最多1张）
    -- ●从手卡丢弃1张「堕福」卡才能发动，从卡组把「堕福的圣曲・风花梦」以外的2张「堕福」卡加入手卡（同名卡最多1张）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	-- 自己的魔法与陷阱区域的「堕福」卡被对方的效果破坏的场合，可以作为代替把墓地的这张卡除外
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.recost)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	c:RegisterEffect(e2)
	
	-- 这些效果发动的回合，自己不能把场上的怪兽的效果发动
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end

-- 这些效果发动的回合，自己不能把场上的怪兽的效果发动
function s.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
	return not (re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE)
end

function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsLocation(LOCATION_MZONE)
end

-- ●丢弃1张手卡才能发动，从卡组把2只「堕福」怪兽加入手卡（同名卡最多1张）
-- ●从手卡丢弃1张「堕福」卡才能发动，从卡组把「堕福的圣曲・风花梦」以外的2张「堕福」卡加入手卡（同名卡最多1张）
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
		if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.costfilter(c)
	return c:IsSetCard(0x666c) and c:IsDiscardable()
end

function s.thfilter1(c)
	return c:IsSetCard(0x666c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.thfilter2(c)
	return c:IsSetCard(0x666c) and not c:IsCode(id) and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local count1=Duel.GetMatchingGroup(s.thfilter1,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode)
	local count2=Duel.GetMatchingGroup(s.thfilter2,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode)
	local b1=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) and count1>=2
	local b2=Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,c) and count2>=2
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return b1 or b2
		else
			return count1>=2 or count2>=2
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(id,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
		end
		if op==0 then
			Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
		else
			Duel.DiscardHand(tp,s.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
		end
		e:SetLabel(0,op)
	else
		local op=0
		if count1>=2 and count2>=2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
		elseif count1>=2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
		end
		e:SetLabel(0,op)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local label,op=e:GetLabel()
	if op==0 then
		local g=Duel.GetMatchingGroup(s.thfilter1,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		if hg then
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hg)
		end
	else
		local g=Duel.GetMatchingGroup(s.thfilter2,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		if hg then
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hg)
		end
	end
end

-- 自己的魔法与陷阱区域的「堕福」卡被对方的效果破坏的场合，可以作为代替把墓地的这张卡除外
function s.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.repfilter(c,tp)
	return c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x666c) and c:GetReasonPlayer()==1-tp
		and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end

function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
