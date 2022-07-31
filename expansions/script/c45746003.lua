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
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.tf3,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local c=e:GetHandler()
		local g=Duel.SelectMatchingCard(tp,cm.tf3,tp,LOCATION_DECK,0,1,1,nil,c)
		local tc=g:GetFirst()
		if c:IsType(TYPE_XYZ) and tc:IsCanOverlay() then
			Duel.Overlay(c,Group.FromCards(tc))
		end
	end)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return r==REASON_XYZ end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler() 
		e:SetProperty(EFFECT_FLAG_EVENT_PLAYER+EFFECT_FLAG_IGNORE_IMMUNE)
		local rc=c:GetReasonCard()
		local reset_flag=RESET_EVENT+RESETS_STANDARD
		local cid=rc:CopyEffect(m,reset_flag,1)
		--Debug.Message(e:GetOwnerPlayer()==rc:GetControler())
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(reset_flag)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetValue(m)
		rc:RegisterEffect(e1,true)
		rc:RegisterFlagEffect(0,reset_flag,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
		if not rc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e2,true)
		end
		e:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	end)
--	c:RegisterEffect(e3)
end
--e3
function cm.tf3(c,mc)
	return c:IsSetCard(0x5880) and mc:IsType(TYPE_XYZ) and c:IsCanOverlay()
end