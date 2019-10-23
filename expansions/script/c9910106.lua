Zcd = {}

function Zcd.AddXyzProcedure(c,f,lv,ct,alterf,desc,maxct,op)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if not maxct then maxct=ct end
	e1:SetCondition(Zcd.XyzCondition(f,lv,ct,maxct,alterf,desc,op))
	e1:SetTarget(Zcd.XyzTarget(f,lv,ct,maxct,alterf,desc,op))
	e1:SetOperation(Zcd.XyzOperation(f,lv,ct,maxct,alterf,desc,op))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
function Zcd.XyzCondition(f,lv,minc,maxc,alterf,desc,op)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local ft=Duel.GetLocationCountFromEx(tp)
				local ct=-ft
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
				end
				if (not min or min<=1) and mg:IsExists(Zcd.XyzAlterFilter,minc,nil,alterf,c,e,tp,op,lv) then
					local ssg=mg:Filter(Zcd.XyzAlterFilter,nil,alterf,c,e,tp,op,lv)
					if ssg:IsExists(Zcd.MFilter1,1,nil) and ssg:IsExists(Zcd.MFilter2,1,nil,c,tp) then return true end
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return ct<minc and Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
			end
end
function Zcd.XyzTarget(f,lv,minc,maxc,alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local ft=Duel.GetLocationCountFromEx(tp)
				local ct=-ft
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
					mg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
				end
				local b1=ct<minc and Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
				local b2=nil
				local ssg=nil
				if (not min or min<=1) and mg:IsExists(Zcd.XyzAlterFilter,minc,nil,alterf,c,e,tp,op,lv) then
					ssg=mg:Filter(Zcd.XyzAlterFilter,nil,alterf,c,e,tp,op,lv)
					b2=ssg:IsExists(Zcd.MFilter1,1,nil) and ssg:IsExists(Zcd.MFilter2,1,nil,c,tp)
				end
				local g=Group.CreateGroup()
				if b2 and (not b1 or Duel.SelectYesNo(tp,desc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					tsg=ssg:FilterSelect(tp,Zcd.MFilter1,1,1,nil)
					local tc1=tsg:GetFirst()
					g:AddCard(tc1)
					ssg:RemoveCard(tc1)
					local flagct=1
					if not Zcd.MFilter2(tc1,c,tp) then
						tsg=ssg:FilterSelect(tp,Zcd.MFilter2,1,1,nil,c,tp)
						local tc2=tsg:GetFirst()
						g:AddCard(tc2)
						ssg:RemoveCard(tc2)
						flagct=2
					end
					local g2=ssg:FilterSelect(tp,Zcd.XyzAlterFilter,minc-flagct,maxc-flagct,nil,alterf,c,e,tp,op,lv)
					g:Merge(g2)
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
function Zcd.XyzOperation(f,lv,minc,maxc,alterf,desc,op)
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
					local sg=Group.CreateGroup()
					local tc=mg:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=mg:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
function Zcd.XyzAlterFilter(c,alterf,xyzc,e,tp,op,lv)
	return alterf(c)
		and c:IsCanBeXyzMaterial(xyzc)
		and Auxiliary.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and (not op or op(e,tp,0,c))
		and c:IsXyzLevel(xyzc,lv)
end
function Zcd.MFilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x952)
end
function Zcd.MFilter2(c,xyzc,tp)
	return Duel.GetLocationCountFromEx(tp,tp,c,xyzc)>0
end
