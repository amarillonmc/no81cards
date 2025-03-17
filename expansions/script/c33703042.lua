--虚拟占卜师 狼-半-仙
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3,s.ovfilter,aux.Stringid(id,0),3,nil)
	c:EnableReviveLimit()
	-- 新增效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.rmcost)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
end
function s.ovfilter(c)
	return c:IsFaceup() and (c:IsRankAbove(7)or c:IsLevelAbove(7))and c:IsType(TYPE_SYNCHRO+TYPE_XYZ)
end
-- 新效果相关函数
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local oc=e:GetHandler():GetOverlayCount()
	e:SetLabel(oc)  -- 记录去除的素材数量
	e:GetHandler():RemoveOverlayCard(tp,oc,oc,REASON_COST)
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) end
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local oc=e:GetLabel()
	if ct>0 then
		local res=false
		if oc>=3 then
			res=Duel.SelectYesNo(tp,aux.Stringid(id,2))
		end
		if res then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,ct,ct,nil)
			Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
			local xc=sg:GetFirst()
			while xc do
				xc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
				xc=sg:GetNext()
			end

		else
			-- 查看并里侧除外
			local g=Duel.GetDecktopGroup(tp,ct)
			Duel.ConfirmDecktop(tp,ct)
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
			local xc=g:GetFirst()
			while xc do
				xc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
				xc=g:GetNext()
			end
		end
		
		-- 追加效果处理
		if oc>=2 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			if not res then
				local exg=Duel.GetDecktopGroup(tp,5)
				Duel.Remove(exg,POS_FACEDOWN,REASON_EFFECT)
				local xc=exg:GetFirst()
				while xc do
					xc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
					xc=exg:GetNext()
				end
	
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,5,5,nil)
				Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
				local xc=sg:GetFirst()
				while xc do
					xc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
					xc=sg:GetNext()
				end

			end
		end
		
		-- 修改后的持续效果
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PREDRAW)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCountLimit(1)
		e1:SetCondition(s.drcon)
		e1:SetOperation(s.drop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_REMOVED,0,1,nil) then
		e:Reset()
	end
	return Duel.IsTurnPlayer(tp) 
		and Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_REMOVED,0,1,nil)
end
function s.ffilter(c)
	return c:GetFlagEffect(id)>0  -- 新增过滤函数
end

-- 新增操作处理函数
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.ffilter,tp,LOCATION_REMOVED,0,nil)
	if #g>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		-- 持续效果
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW,1)
		Duel.RegisterEffect(e1,tp)
	end
end