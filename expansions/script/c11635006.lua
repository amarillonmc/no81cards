--爆弹石像鬼
local m=11635006
local cm=_G["c"..m]
function cm.initial_effect(c)
	--aux.AddXyzProcedure(c,cm.matfilter,1,2,nil,nil,99)
	c:EnableReviveLimit() 
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(function(e,c,og,min,max)
				if c==nil then return true end
				local tp=c:GetControler()
				return Duel.CheckXyzMaterial(c,cm.matfilter,1,2,99,Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0))
			end)
	e0:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then return true end
				local g=Duel.SelectXyzMaterial(tp,c,cm.matfilter,1,2,99,Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0))
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end)
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				local sg=Group.CreateGroup()
				if og and not min then
					for tc in aux.Next(og) do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					for tc in aux.Next(mg) do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(function(e,c,rc)if rc==e:GetHandler() then return c:GetOriginalLevel() else return c:GetLevel()end end)
	c:RegisterEffect(e1)
	--01
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1) 
	--to extra 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_TOEXTRA)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCondition(cm.con3)
	e3:SetCountLimit(1,m+1)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)  
end
function cm.matfilter(c)
	return c.SetCard_shixianggui
end
cm.SetCard_shixianggui=true
--
function cm.filter1(c)
	return c.SetCard_shixianggui and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0  and c:IsCanOverlay()
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local og=g:Select(tp,1,99,nil)
		Duel.Overlay(c,og)
	end
end
--
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end

function cm.filter3(c,tp,e)
	return c.SetCard_shixianggui and c:IsType(TYPE_MONSTER)  and not c:IsForbidden() 
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local og=c:GetOverlayGroup()
		if #og==0 then return end
		Duel.SendtoGrave(og,REASON_EFFECT)
		local cg=Duel.GetOperatedGroup()
		Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)		
		local ct=cg:GetClassCount(Card.GetCode)
		if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			if ct>=1 then 
				
				Duel.Damage(1-tp,#cg*100,REASON_EFFECT) 
			end
			local hct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)
			if ct>=2 and hct>0 then 
				Duel.Damage(1-tp,hct*100,REASON_EFFECT) 
			end
			if ct>=3 then 
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_DELAY)
				e1:SetCode(EVENT_DAMAGE)
				e1:SetCondition(cm.dacon)
				e1:SetOperation(cm.daop)
				e1:SetReset(RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e1,tp)  
			end
			local ct1=Duel.GetLocationCount(tp,LOCATION_SZONE)
			if ct>=4 and ct1>0 and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_GRAVE,0,1,nil,tp,e) then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)  
				local g=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,1,ct1,nil,tp,e)
				local tc=g:GetFirst() 
				while tc do
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
					local e1=Effect.CreateEffect(c)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
					tc:RegisterEffect(e1,true)
					tc=g:GetNext()
				end
			end
		end

	end
end
function cm.dacon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetLP(1-tp)>0 and bit.band(r,REASON_BATTLE)==0 and re:IsActiveType(TYPE_MONSTER) and re and not re:GetHandler():IsCode(m)
end
function cm.daop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	--Duel.Damage(1-tp,100,REASON_EFFECT)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-100)
end
--
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end