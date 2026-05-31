-- 妖血鬼 吸血鬼 (Yogetsuki Vampire / Vampire XYZ)
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2,s.ovfilter,aux.Stringid(id,0),2,s.xyzop)
	c:EnableReviveLimit()
	
	-- 不能作为超量召唤的素材
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	-- ①：自己·对方回合，1回合1次，拔素材破坏对方场上1张卡，之后进行特殊处理（不取对象）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end

-- 超量重叠召唤的条件判定
function s.ovfilter(c)
	local tp=c:GetOwner()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x8e)
		and c:GetOverlayGroup():IsExists(Card.GetOwner,1,nil,1-tp)
end

-- 注册重叠召唤的1回合1次限制
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

-- ① 效果 Cost
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

-- ① 效果 Target（不取对象）
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

-- ① 效果 Operation
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		
		-- 在破坏前记录卡的种类
		local is_monster=tc:IsType(TYPE_MONSTER)
		local is_st=tc:IsType(TYPE_SPELL+TYPE_TRAP)
		
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			-- 检查被破坏的卡是否在可以操作的公共区域（墓地、除外区、额外卡组）
			local loc=tc:GetLocation()
			if (loc&(LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA))==0 then return end
			
			if is_monster then
				-- 怪兽的场合：里侧除外 或 在自己场上特殊召唤
				local b1=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				local b2=tc:IsAbleToRemove(tp,POS_FACEDOWN)
				if b1 or b2 then
					local op=0
					if b1 and b2 then
						op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3)) -- 0:里侧除外, 1:特殊召唤
					elseif b1 then
						op=1
					else
						op=0
					end
					
					if op==0 then
						Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
					else
						Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
					end
				end
			elseif is_st then
				-- 魔陷的场合：里侧除外 或 在自己场上盖放
				local b1=tc:IsSSetable()
				local b2=tc:IsAbleToRemove(tp,POS_FACEDOWN)
				if b1 or b2 then
					local op=0
					if b1 and b2 then
						op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,4)) -- 0:里侧除外, 1:盖放
					elseif b1 then
						op=1
					else
						op=0
					end
					
					if op==0 then
						Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
					else
						Duel.SSet(tp,tc)
					end
				end
			end
		end
	end
end