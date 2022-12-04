local m=15000398
local cm=_G["c"..m]
cm.name="克瑞姆希尔·流离魔剑"
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.XyzCondition2(nil,11,3,3,cm.ovfilter,aux.Stringid(m,0),cm.xyzop))
	e1:SetTarget(cm.XyzTarget2(nil,11,3,3,cm.ovfilter,aux.Stringid(m,0),cm.xyzop))
	e1:SetOperation(cm.XyzOperation2(nil,11,3,3,cm.ovfilter,aux.Stringid(m,0),cm.xyzop))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.negcon)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	--e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(cm.descon)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_XYZ) then
			Duel.RegisterFlagEffect(0,15000398,RESET_PHASE+PHASE_END,0,1,tc:GetCode())
		end
		tc=eg:GetNext()
	end
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(0,15000398)>0 and Duel.GetFlagEffect(tp,15000399)==0 end
	Duel.RegisterFlagEffect(tp,15000399,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.ovfilter(c)
	local res=0
	if Duel.GetFlagEffect(0,15000398)~=0 then
		for k,i in ipairs{Duel.GetFlagEffectLabel(0,15000398)} do
			if i==c:GetCode() then
				res=1
			end
		end
	end
	return res==1
end
function cm.XyzAlterFilter(c,alterf,xyzc,e,tp,op)
	return alterf(c) and Duel.GetLocationCountFromEx(tp,tp,nil,xyzc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and (not op or op(e,tp,0,c))
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
					mg=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
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
					mg=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
				end
				local b1=Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
				local b2=(not min or min<=1) and mg:IsExists(cm.XyzAlterFilter,1,nil,alterf,c,e,tp,op)
				local g=nil
				if b2 and (not b1 or Duel.SelectYesNo(tp,desc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
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
							Duel.Overlay(c,mg)
							mg:DeleteGroup()
							return
						end
					end
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local race,att=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE,CHAININFO_TRIGGERING_ATTRIBUTE)
	return re:IsActiveType(TYPE_MONSTER) and re:IsActivated() and (race&RACE_DRAGON>0 or att&ATTRIBUTE_DARK>0) and e:GetHandler():GetOverlayCount()>0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,15000398)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g~=0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end