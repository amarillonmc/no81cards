local m=15004012
local cm=_G["c"..m]
cm.name="在世界墟77祈祷光明"
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.XyzCondition2(nil,4,3,3,cm.ovfilter,aux.Stringid(m,0)))
	e1:SetTarget(cm.XyzTarget2(nil,4,3,3,cm.ovfilter,aux.Stringid(m,0)))
	e1:SetOperation(cm.XyzOperation2(nil,4,3,3,cm.ovfilter,aux.Stringid(m,0)))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(1)
	e2:SetCondition(cm.actcon)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(cm.immcon)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e4:SetCode(EVENT_CHAINING)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.negcon)
	e4:SetTarget(cm.negtg)
	e4:SetOperation(cm.negop)
	c:RegisterEffect(e4)
	--adjust
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(cm.adjop)
	c:RegisterEffect(e5)
end
function cm.adjop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(15004010)~=0 then c:ResetFlagEffect(15004010) end
	if c:GetFlagEffect(15004011)~=0 then c:ResetFlagEffect(15004011) end
	if c:GetFlagEffect(15004012)~=0 then c:ResetFlagEffect(15004012) end
	if c:GetOverlayGroup():IsExists(cm.ofilter,1,nil,TYPE_MONSTER) then c:RegisterFlagEffect(15004010,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3)) end
	if c:GetOverlayGroup():IsExists(cm.ofilter,1,nil,TYPE_SPELL) then c:RegisterFlagEffect(15004011,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4)) end
	if c:GetOverlayGroup():IsExists(cm.ofilter,1,nil,TYPE_TRAP) then c:RegisterFlagEffect(15004012,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5)) end
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsCode(15004011)
end
function cm.XyzAlterFilter(c,alterf,xyzc,e,tp,op)
	return alterf(c) and Duel.GetLocationCountFromEx(tp,tp,c,xyzc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and (not op or op(e,tp,0,c)) and c:IsAbleToDeckAsCost()
end
function cm.XyzCondition2(f,lv,minc,maxc,alterf,desc,op)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				if (not min or min<=1) and mg:IsExists(cm.XyzAlterFilter,1,nil,alterf,c,e,tp,op) then
					return true
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
			end
end
function cm.XyzTarget2(f,lv,minc,maxc,alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local b1=Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
				local b2=(not min or min<=1) and mg:IsExists(cm.XyzAlterFilter,1,nil,alterf,c,e,tp,op)
				local g=nil
				if b2 and (not b1 or Duel.SelectYesNo(tp,desc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
					g=mg:FilterSelect(tp,cm.XyzAlterFilter,1,1,nil,alterf,c,e,tp,op)
					if op then op(e,tp,1,g:GetFirst()) end
				else
					e:SetLabel(0)
					g=Duel.SelectXyzMaterial(tp,c,f,lv,minc,maxc,og)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function cm.XyzOperation2(f,lv,minc,maxc,alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.SendtoGrave(mg2,REASON_RULE)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					if not (og and not min) then
						local mg=e:GetLabelObject()
						if e:GetLabel()==1 then
							Duel.SendtoDeck(mg:GetFirst(),nil,1,REASON_COST)
							local fg=Duel.GetDecktopGroup(c:GetControler(),1)
							Duel.Overlay(c,fg)
							mg:DeleteGroup()
							return
						end
					end
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
function cm.ofilter(c,type)
	return bit.band(c:GetOriginalType(),type)~=0
end
function cm.actcon(e)
	return (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()) and e:GetHandler():GetOverlayGroup():IsExists(cm.ofilter,1,nil,TYPE_MONSTER)
end
function cm.immcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(cm.ofilter,1,nil,TYPE_SPELL)
end
function cm.efilter(e,te)
	if not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev) and e:GetHandler():GetOverlayGroup():IsExists(cm.ofilter,1,nil,TYPE_TRAP)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end