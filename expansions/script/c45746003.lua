--幻影旅团·3 玛奇
local m=45746003
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5880),4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		local b2=Duel.IsExistingMatchingCard(function(c)return c:IsFaceup() and c:IsSetCard(0x5880) and c:IsCanOverlay()end,tp,LOCATION_REMOVED,0,1,nil)
		if chk==0 then return b1 or b2 end
		local off=1
		local ops,opval={},{}
		if b1 then
			ops[off]=aux.Stringid(m,0)
			opval[off]=0
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(m,1)
			opval[off]=1
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		e:SetLabel(sel)
		if sel==0 then
			e:SetCategory(CATEGORY_REMOVE)
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
		else
			e:SetCategory(0)
		end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local sel=e:GetLabel()
		if sel==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		else
			if not c:IsRelateToEffect(e) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local g=Duel.SelectMatchingCard(tp,function(c)return c:IsFaceup() and c:IsSetCard(0x5880) and c:IsCanOverlay()end,tp,LOCATION_REMOVED,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.Overlay(c,g)
			end
		end
	end)
	c:RegisterEffect(e1)
--e3
function cm.tf3(c,mc)
	return c:IsSetCard(0x5880) and mc:IsType(TYPE_XYZ) and c:IsCanOverlay()
end