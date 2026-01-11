--织梦的裁断
local s,id,o=GetID()
function s.initial_effect(c)

	--①：展示封锁
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--②：回收
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

-- === 效果① ===
function s.rvfilter(c)
	return c:IsSetCard(0x613) and c:IsType(TYPE_SYNCHRO+TYPE_LINK) and not c:IsPublic()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_EXTRA,0,1,nil) end
	-- 不能对应这张卡的发动让卡的效果发动
	Duel.SetChainLimit(aux.FALSE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	-- 记录种类
	local tc=g:GetFirst()
	local ty=0
	if tc:IsType(TYPE_SYNCHRO) then ty=ty|TYPE_SYNCHRO end
	if tc:IsType(TYPE_LINK) then ty=ty|TYPE_LINK end
	e:SetLabel(ty)
	-- 注册持续效果：监听连锁
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetLabel(ty)
	e1:SetOperation(s.chainop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	
	-- 提示信息
	local desc = 0
	if (ty & TYPE_SYNCHRO) ~= 0 and (ty & TYPE_LINK) ~= 0 then desc = aux.Stringid(id,2) -- 同调·连接
	elseif (ty & TYPE_SYNCHRO) ~= 0 then desc = aux.Stringid(id,3) -- 同调
	else desc = aux.Stringid(id,4) end -- 连接
end

function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local ty=e:GetLabel()
	-- 自己的水属性怪兽
	if rp==tp and rc:IsAttribute(ATTRIBUTE_WATER) and rc:IsType(TYPE_MONSTER) then
		-- 且种类相同
		local match=false
		if (ty & TYPE_SYNCHRO) ~= 0 and rc:IsType(TYPE_SYNCHRO) then match=true end
		if (ty & TYPE_LINK) ~= 0 and rc:IsType(TYPE_LINK) then match=true end
		
		if match then
			Duel.SetChainLimit(function(e,rp,tp) return rp==tp end)
		end
	end
end

-- === 效果② ===
function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsSetCard(0x613) and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and c:IsReason(REASON_EFFECT)
end

function s.fiendfilter(c)
	return c:IsSetCard(0x613) and c:IsRace(RACE_FIEND) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end

function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,e:GetHandler(),tp)
		and Duel.IsExistingMatchingCard(s.fiendfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end