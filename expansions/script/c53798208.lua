--9星怪兽×2
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,2)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev)
end
function s.attfilter(c)
	return c:IsCanOverlay()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	
	-- 转换触发位置为标准区域常量，以便进行筛选
	local uloc=0
	if loc&LOCATION_HAND~=0 then uloc=uloc|LOCATION_HAND end
	if loc&LOCATION_ONFIELD~=0 then uloc=uloc|LOCATION_ONFIELD end
	if loc&LOCATION_GRAVE~=0 then uloc=uloc|LOCATION_GRAVE end
	
	-- 选项1：吸收素材（卡名一回合一次，分区域）
	-- 根据触发位置决定检查哪个Flag
	local flag=0
	if uloc&LOCATION_HAND~=0 then flag=id
	elseif uloc&LOCATION_ONFIELD~=0 then flag=id+o
	elseif uloc&LOCATION_GRAVE~=0 then flag=id+o*2
	end
	
	local b1=false
	-- 检查：对应Flag未被注册，自身是XYZ怪兽，且对应区域有可以作为素材的卡（排除触发卡本身）
	if flag~=0 and Duel.GetFlagEffect(tp,flag)==0 and c:IsType(TYPE_XYZ) 
		and Duel.IsExistingMatchingCard(s.attfilter,tp,uloc,0,1,Group.FromCards(c,re:GetHandler())) then
		b1=true
	end

	-- 选项2：去除3个素材（软一回合一次）
	-- 使用 c:GetFlagEffect 检查该卡实例是否已使用过此效果
	local b2=c:GetFlagEffect(id+o*3)==0 and c:CheckRemoveOverlayCard(tp,3,REASON_COST)

	if chk==0 then return b1 or b2 end

	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2})
		
	if op==1 then
		-- 注册玩家层面的Flag（卡名限制）
		Duel.RegisterFlagEffect(tp,flag,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		-- 从对应区域选择1张卡（除触发卡外）
		local g=Duel.SelectMatchingCard(tp,s.attfilter,tp,uloc,0,1,1,Group.FromCards(c,re:GetHandler()))
		if #g>0 then
			Duel.Overlay(c,g)
		end
	elseif op==2 then
		-- 注册卡片层面的Flag（软限制），随卡片离场或回合结束重置
		c:RegisterFlagEffect(id+o*3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		c:RemoveOverlayCard(tp,3,3,REASON_COST)
	end
	
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end