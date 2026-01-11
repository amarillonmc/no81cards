--剑装机岚·靛红
local s,id,o=GetID()
function s.initial_effect(c)
	--①：手卡同调素材
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetValue(s.matval)
	c:RegisterEffect(e1)
	
	--②：展示抽1 + 召唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.effcost)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
	
	--③：改名
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(6110003) -- 剑装机岚 #EF0000
	c:RegisterEffect(e3)
end

-- === 效果① ===
function s.matval(e,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK)
end

-- === 效果② ===
function s.revfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsPublic()
end
function s.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return s.revfilter(c) 
		and Duel.IsExistingMatchingCard(s.revfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.revfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end

--②：Target - 选择效果
function s.nsfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsSummonable(true,nil)
end
function s.rmfilter(c)
	return c:IsRace(RACE_MACHINE) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	--选项1：召唤机械族
	local b1=Duel.IsExistingMatchingCard(s.nsfilter,tp,LOCATION_HAND,0,1,nil)
	--选项2：抽1，处理1
	local b2=Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_HAND,0,1,nil)
	
	if chk==0 then return b1 or b2 end
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	end
	e:SetLabel(op)
	
	if op==0 then
		e:SetCategory(CATEGORY_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
	else
		e:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		--由于不确定是送墓还是除外，Info只能大概给一下，或者不给具体对象
	end
end

--②：Operation
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		--召唤
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,s.nsfilter,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 then
			Duel.Summon(tp,g:GetFirst(),true,nil)
		end
	else
		--抽1
		if Duel.Draw(tp,1,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			--选一张机械族送墓或除外
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3)) --提示选择要处理的卡
			local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_HAND,0,1,1,nil)
			if #g>0 then
				local tc=g:GetFirst()
				--判断能否送墓/能否除外，如果都能则让玩家选
				local can_tograve=tc:IsAbleToGrave()
				local can_remove=tc:IsAbleToRemove()
				local sub_op=0
				
				if can_tograve and can_remove then
					sub_op=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5)) -- "送去墓地", "除外"
				elseif can_tograve then
					sub_op=0
				else
					sub_op=1
				end
				
				if sub_op==0 then
					Duel.SendtoGrave(tc,REASON_EFFECT)
				else
					Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
				end
			end
		end
	end
end