local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,2,3)
	
	--treat 8 as 4 for this card


	--Quick effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1,id)
	e4:SetCost(s.cost)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
end

function s.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,4) or (c:IsXyzLevel(xyzc,8) and c:IsControler(xyzc:GetControler()))
end
function s.xyzcheck(g,xyzc,tp)
	local function check_combination(cards,index,current_val,used_8)
		if index>#cards then return current_val==3 end
		local tc=cards[index]
		local res=false
		if tc:IsXyzLevel(xyzc,4) then
			res=check_combination(cards,index+1,current_val+1,used_8)
		end
		if not res and not used_8 and tc:IsXyzLevel(xyzc,8) and tc:IsControler(tp) then
			res=check_combination(cards,index+1,current_val+2,true)
		end
		return res
	end
	
	local cards={}
	for tc in aux.Next(g) do table.insert(cards,tc) end
	return check_combination(cards,1,0,false)
end

-- Functions for alternate Xyz material
function s.lvtg(e,c)
	return c:IsLevel(8)
end
function s.lvval(e,c,rc)
	if rc==e:GetHandler() then return 4 else return c:GetLevel() end
end
function s.matval(e,c)
	return not c or c:GetOriginalCode()==id
end

-- Functions for Quick Effect
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		-- ●那只怪兽的效果无效。
		if tc:IsCanBeDisabledByEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
		
		-- ●自己超量召唤的场合，那只对方怪兽也能作为超量素材。
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_XYZ_MATERIAL)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		
		-- ●把那只怪兽在超量召唤使用的场合，可以把那个等级当作4星或8星使用。
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_XYZ_LEVEL)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetValue(s.xyzlv)
		e4:SetLabel(4)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetLabel(8)
		tc:RegisterEffect(e5)
	end
end
function s.xyzlv(e,c,rc)
	return c:GetLevel()+0x10000*e:GetLabel()
end