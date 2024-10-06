--幽冥楼阁の亡灵公主
function c37900035.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,8,3,c37900035.ov,aux.Stringid(37900035,0),3,c37900035.xyzop)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37900035,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,37900035)
	e1:SetCost(c37900035.cost)
	e1:SetTarget(c37900035.tg)
	e1:SetOperation(c37900035.op)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37900035,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,37900036)
	e2:SetCost(c37900035.cost)
	e2:SetTarget(c37900035.tg2)
	e2:SetOperation(c37900035.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c37900035.con3)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)	
end
function c37900035.ov(c)
	return c:IsFaceup() and c:IsCode(37900015)
end
function c37900035.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,37900035)==0 end
	Duel.RegisterFlagEffect(tp,37900035,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c37900035.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,3000) end
	Duel.PayLPCost(tp,3000)
end
function c37900035.q(c)
	return c:IsCanOverlay() and c:IsType(TYPE_MONSTER) and not (c:IsLocation(LOCATION_REMOVED) and c:IsFacedown())
end
function c37900035.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsType(TYPE_XYZ) and Duel.IsExistingTarget(c37900035.q,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c37900035.q,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,1,c)
end
function c37900035.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c37900035.w(c,e,tp)
	return c:IsStatus(STATUS_PROC_COMPLETE) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c37900035.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(c37900035.w,nil,e,tp)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
end
function c37900035.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabelObject(c)
	local g=c:GetOverlayGroup():Filter(c37900035.w,nil,e,tp)
	if g:GetCount()>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local ct=nil
		if tc:IsType(TYPE_FUSION) then 
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
		elseif tc:IsType(TYPE_SYNCHRO) then 
			ct=Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,true,true,POS_FACEUP)
		elseif tc:IsType(TYPE_XYZ) then 
			ct=Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)	
		elseif tc:IsType(SUMMON_TYPE_LINK) then 
			ct=Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,true,true,POS_FACEUP)	
		else			
			ct=Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		end	
			if ct==1 and tc:IsFaceup() then	
			tc:RegisterFlagEffect(37900035,RESET_EVENT+RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetLabelObject(e:GetLabelObject())
			e1:SetCountLimit(1)
			e1:SetOperation(c37900035.reop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			c:CreateEffectRelation(e1)
			tc:CreateEffectRelation(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetValue(c37900035.limit)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_LEAVE_FIELD)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetLabelObject(tc)
			e3:SetCountLimit(1)
			e3:SetOperation(c37900035.desop)
			c:RegisterEffect(e3,true)
			tc:CreateEffectRelation(e3)
			end				
	end
end
function c37900035.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if Duel.GetTurnPlayer()==1-tp and tc and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)  and tc:IsFaceup() and c:IsCanOverlay() and tc:IsType(TYPE_XYZ) then
		if c:IsType(TYPE_XYZ) then
		local og=c:GetOverlayGroup()
		if og:GetCount()>0 then
		Duel.SendtoGrave(og,REASON_RULE)
		end
		end
	Duel.Overlay(tc,Group.FromCards(c))	
	e:Reset()
	end	
end
function c37900035.limit(e,c,st)
	return st==SUMMON_TYPE_XYZ
end
function c37900035.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsRelateToEffect,tp,LOCATION_MZONE,0,nil,e)
	if g:GetCount()>0 then
	Duel.Destroy(g,REASON_RULE)
	end
	e:Reset()
end
function c37900035.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,37900003)>0 or Duel.GetFlagEffect(1-tp,37900003)>0
end