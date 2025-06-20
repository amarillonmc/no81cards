--万物的见证者·洁蒂丝
local m=60002226
local cm=_G["c"..m]
function cm.initial_effect(c)   
	for i=0,0xffff do
		c:EnableCounterPermit(i,LOCATION_ONFIELD)
	end
	--race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetRange(0xff)
	e1:SetValue(0xfffffff)
	c:RegisterEffect(e1)
	--att
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetRange(0xff)
	e1:SetValue(0xff)
	c:RegisterEffect(e1)
	
	--爆能强化
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	--进化
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(cm.cos5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(m,3))
	--e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	--e1:SetType(EFFECT_TYPE_IGNITION)
	--e1:SetRange(LOCATION_HAND)
	--e1:SetCost(cm.spcost)
	--e1:SetCondition(cm.spcon2)
	--e1:SetTarget(cm.sptg)
	--e1:SetOperation(cm.spop)
	--c:RegisterEffect(e1)
end

if not cm.enable_all_setname then
	cm.enable_all_setname=true
	cm._is_set_card=Card.IsSetCard
	Card.IsSetCard=function (c,...)
		return c:IsOriginalCodeRule(m) or cm._is_set_card(c,...)
	end
	cm._is_link_set_card=Card.IsLinkSetCard
	Card.IsLinkSetCard=function (c,...)
		return c:IsOriginalCodeRule(m) or cm._is_link_set_card(c,...)
	end
	cm._is_fusion_set_card=Card.IsFusionSetCard
	Card.IsFusionSetCard=function (c,...)
		return c:IsOriginalCodeRule(m) or cm._is_fusion_set_card(c,...)
	end
	cm._is_previous_set_card=Card.IsPreviousSetCard
	Card.IsPreviousSetCard=function (c,...)
		return c:IsOriginalCodeRule(m) or cm._is_previous_set_card(c,...)
	end
	cm._is_original_set_card=Card.IsOriginalSetCard
	Card.IsOriginalSetCard=function (c,...)
		return c:IsOriginalCodeRule(m) or cm._is_original_set_card(c,...)
	end


	cm._is_code=Card.IsCode
	Card.IsCode=function (c,...)
		return c:IsOriginalCodeRule(m) or cm._is_code(c,...)
	end
	cm._is_link_code=Card.IsLinkCode
	Card.IsLinkCode=function (c,...)
		return c:IsOriginalCodeRule(m) or cm._is_link_code(c,...)
	end
	cm._is_fusion_code=Card.IsFusionCode
	Card.IsFusionCode=function (c,...)
		return c:IsOriginalCodeRule(m) or cm._is_fusion_code(c,...)
	end
	cm._is_original_code_rule=Card.IsOriginalCodeRule
	Card.IsOriginalCodeRule=function (c,...)
		return cm._is_original_code_rule(c,m,...)
	end


	cm._is_code_listed=aux.IsCodeListed
	aux.IsCodeListed=function (c,code,...)
		return c:IsOriginalCodeRule(m) or cm._is_code_listed(c,code,...)
	end
end

function cm.con2(e,c,minc)
	if c==nil then return true end
	return minc<=1 and Duel.CheckTribute(c,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,1,Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE))
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	for tc in aux.Next(g) do
		if tc:IsLocation(LOCATION_GRAVE) then 
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function cm.cos5f1(c)
	return c:GetFlagEffect(m)>0 and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function cm.cos5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cos5f1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cos5f1,tp,LOCATION_GRAVE,0,1,99,nil)
	e:SetLabel(Duel.SendtoDeck(g,tp,2,REASON_COST))
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local dam=e:GetLabel()
	if not e:GetHandler():IsRelateToEffect(e) or not e:GetHandler():IsFaceup() then return end
	if dam>=1 then
		if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,cm.xfilter,tp,0,LOCATION_MZONE,1,1,nil)
			Duel.Destroy(g:GetFirst(),REASON_EFFECT)
		end
		if dam>=2 then
			Duel.Draw(tp,1,REASON_EFFECT)
			if dam>=3 then
				Duel.Recover(tp,1000,REASON_EFFECT)
				if dam>=4 then
					--avoid damage
					local e4=Effect.CreateEffect(e:GetHandler())
					e4:SetType(EFFECT_TYPE_FIELD)
					e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e4:SetCode(EFFECT_CHANGE_DAMAGE)
					e4:SetTargetRange(1,0)
					e4:SetValue(cm.damval)
					e4:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterFlagEffect(tp,70002169,RESET_PHASE+PHASE_END,0,2)
					Duel.RegisterEffect(e4,tp)
					local e4=Effect.CreateEffect(e:GetHandler())
					e4:SetType(EFFECT_TYPE_FIELD)
					e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
					e4:SetTargetRange(1,0)
					e4:SetValue(cm.damval)
					e4:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterFlagEffect(tp,70002169,RESET_PHASE+PHASE_END,0,2)
					Duel.RegisterEffect(e4,tp)
				end
			end
		end
	end
end
function cm.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local sg=g:Filter(Card.IsFaceup,nil)
	return sg and sg:GetClassCount(Card.GetRace)>=2
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):Filter(Card.IsFaceup,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
	Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,g) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,0,0,0)
end
function cm.thfilter(c,g)
	local sg=g
	sg:AddCard(c)
	if sg:GetClassCount(Card.GetRace)==#sg and sg:GetClassCount(Card.GetAttribute)==#sg then
		return true
	else
		return false
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):Filter(Card.IsFaceup,nil)
	local ag=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,g)
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(ag,nil,REASON_EFFECT)~=0 then
		Duel.Summon(tp,c,true,nil)
	end
end
--function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	--local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	--local sg=g:Filter(Card.IsFaceup,nil)
	--return sg and sg:GetClassCount(Card.GetRace)>=2 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,60002223)
--end
--function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return true end
	--if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	--local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	--if g:GetCount()>0 then
		--Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	--end
--end
--function cm.filter(c,e,tp)
	--return c:IsSetCard(0x5622) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
--end
--function cm.xfilter(c)
	--return c:IsType(TYPE_MONSTER)
--end







