--迷茫的坚持
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 获取可除外的候选卡片（手卡+墓地+卡组最上方）
function s.getcostcandidates(tp)
	local group=Group.CreateGroup()
	local hand=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	group:Merge(hand)
	local grave=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	group:Merge(grave)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
		local decktop=Duel.GetDecktopGroup(tp,2)
		group:Merge(decktop)
	end
	return group
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local candidates=s.getcostcandidates(tp)
	if chk==0 then return #candidates>=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local costg=candidates:Select(tp,2,2,nil)
	if #costg==0 then return end
	Duel.Remove(costg,POS_FACEUP,REASON_COST)
end

function s.objfilter(c, tp, e)
	if not (c:IsFaceup() and c:IsOnField() and c:IsControler(tp)) then return false end
	local ok = false
	local objtype = 0
	if c:IsType(TYPE_FUSION) then
		ok = true
		objtype = TYPE_FUSION
	elseif c:IsType(TYPE_SYNCHRO) then
		ok = true
		objtype = TYPE_SYNCHRO
	elseif c:IsType(TYPE_XYZ) then
		ok = true
		objtype = TYPE_XYZ
	elseif c:IsType(TYPE_LINK) then
		ok = true
		objtype = TYPE_LINK
	end
	if not ok then return false end
	return Duel.IsExistingMatchingCard(s.extrafilter, tp, LOCATION_EXTRA, 0, 1, nil, objtype)
end

-- 检查额外卡组是否存在与对象种类相同且可除外的怪兽
function s.extrafilter(c,objtype)
	return ((objtype==TYPE_FUSION and c:IsType(TYPE_FUSION))
		or (objtype==TYPE_SYNCHRO and c:IsType(TYPE_SYNCHRO))
		or (objtype==TYPE_XYZ and c:IsType(TYPE_XYZ))
		or (objtype==TYPE_LINK and c:IsType(TYPE_LINK))) and c:IsAbleToRemove()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.objfilter(chkc, tp, e) end
	if chk==0 then
		local obj=Duel.IsExistingTarget(s.objfilter,tp,LOCATION_MZONE,0,1,nil, tp, e)
		if not obj then return false end
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectTarget(tp,s.objfilter,tp,LOCATION_MZONE,0,1,1,nil, tp, e)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_FUSION) then
		objtype = TYPE_FUSION
	elseif tc:IsType(TYPE_SYNCHRO) then
		objtype = TYPE_SYNCHRO
	elseif tc:IsType(TYPE_XYZ) then
		objtype = TYPE_XYZ
	elseif tc:IsType(TYPE_LINK) then
		objtype = TYPE_LINK
	end
	local extra=Duel.GetMatchingGroup(s.extrafilter,tp,LOCATION_EXTRA,0,nil,objtype)
	if #extra>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local extracard=extra:Select(tp,1,1,nil):GetFirst()
		if not extracard then return end
		Duel.Remove(extracard,POS_FACEUP,REASON_EFFECT)
		local code=extracard:GetOriginalCodeRule()
		local cid=0
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		cid=tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,3))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetLabelObject(e1)
		e2:SetLabel(cid)
		e2:SetOperation(s.rstop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
	Duel.BreakEffect()
	Duel.ShuffleDeck(tp)
end

function s.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

function debug_log(...)
    local args = {...}
    local message = table.concat(args, " ")
    error("[DEBUG] " .. message, 0) -- 注意最后的 0，表示不显示调用栈信息，只输出消息
end