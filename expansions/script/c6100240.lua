--无回响之祈
local s,id,o=GetID()
function s.initial_effect(c)
	--①：抽卡并置顶
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id) 
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--②：破坏代替
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1) 
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end

-- === 效果① ===
function s.topfilter(c)
	return c:IsSetCard(0x613)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsPlayerCanDraw(tp,1) 
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2
		and Duel.IsExistingMatchingCard(s.topfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 先抽卡
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	
	-- 检查卡组是否有“朦雨”卡
	local g=Duel.GetMatchingGroup(s.topfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2)) -- 提示文本：选择置顶的卡
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
		end
	end
end

-- === 效果② ===
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x613) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) 
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end

function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_REPLACE)
end