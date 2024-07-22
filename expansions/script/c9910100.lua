if QutryZcd then return end
QutryZcd = {}

function QutryZcd.AddXyzProcedure(c,f,lv,ct,alterf,maxct,op)
	local desc=aux.Stringid(9910100,0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if not maxct then maxct=ct end
	e1:SetCondition(QutryZcd.XyzCondition(f,lv,ct,maxct,alterf,desc,op))
	e1:SetTarget(QutryZcd.XyzTarget(f,lv,ct,maxct,alterf,desc,op))
	e1:SetOperation(QutryZcd.XyzOperation(f,lv,ct,maxct,alterf,desc,op))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
function QutryZcd.XyzCondition(f,lv,minc,maxc,alterf,desc,op)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
				end
				if (not min or min<=1) and mg:IsExists(QutryZcd.XyzAlterFilter,minc,nil,alterf,c,e,tp,op,lv) then
					local ssg=mg:Filter(QutryZcd.XyzAlterFilter,nil,alterf,c,e,tp,op,lv)
					if ssg:IsExists(QutryZcd.MFilter1,1,nil) and ssg:IsExists(QutryZcd.MFilter2,1,nil,c,tp)
						and ssg:IsExists(Card.IsLocation,1,nil,LOCATION_SZONE) then return true end
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
function QutryZcd.XyzTarget(f,lv,minc,maxc,alterf,desc,op)
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
					mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
				end
				local b1=Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
				local b2=nil
				local ssg=nil
				if (not min or min<=1) and mg:IsExists(QutryZcd.XyzAlterFilter,minc,nil,alterf,c,e,tp,op,lv) then
					ssg=mg:Filter(QutryZcd.XyzAlterFilter,nil,alterf,c,e,tp,op,lv)
					b2=ssg:IsExists(QutryZcd.MFilter1,1,nil) and ssg:IsExists(QutryZcd.MFilter2,1,nil,c,tp)
						and ssg:IsExists(Card.IsLocation,1,nil,LOCATION_SZONE)
				end
				local g=Group.CreateGroup()
				if b2 and (not b1 or Duel.SelectYesNo(tp,desc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					tsg=ssg:FilterSelect(tp,QutryZcd.MFilter1,1,1,nil)
					local tc1=tsg:GetFirst()
					g:AddCard(tc1)
					ssg:RemoveCard(tc1)
					local flagct=1
					if not QutryZcd.MFilter2(tc1,c,tp) then
						tsg=ssg:FilterSelect(tp,QutryZcd.MFilter2,1,1,nil,c,tp)
						local tc2=tsg:GetFirst()
						g:AddCard(tc2)
						ssg:RemoveCard(tc2)
						flagct=2
					end
					local g2=ssg:FilterSelect(tp,QutryZcd.XyzAlterFilter,minc-flagct,maxc-flagct,nil,alterf,c,e,tp,op,lv)
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
function QutryZcd.XyzOperation(f,lv,minc,maxc,alterf,desc,op)
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
function QutryZcd.XyzAlterFilter(c,alterf,xyzc,e,tp,op,lv)
	return alterf(c)
		and c:IsCanBeXyzMaterial(xyzc)
		and Auxiliary.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and (not op or op(e,tp,0,c))
		and c:IsXyzLevel(xyzc,lv)
end
function QutryZcd.MFilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9958)
end
function QutryZcd.MFilter2(c,xyzc,tp)
	return Duel.GetLocationCountFromEx(tp,tp,c,xyzc)>0
end
function QutryZcd.SelfSpsummonEffect(c,extag,exchk1,exchk2,beftd1,beftd2,afttd1,afttd2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+extag)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,c:GetOriginalCode())
	e1:SetCost(QutryZcd.SpCost())
	e1:SetTarget(QutryZcd.SpTg(exchk1,exchk2))
	e1:SetOperation(QutryZcd.SpOp(beftd1,beftd2,afttd1,afttd2))
	c:RegisterEffect(e1)
end
function QutryZcd.SpCost()
	return  function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then return not e:GetHandler():IsPublic() end
			end
end
function QutryZcd.XFilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function QutryZcd.SpTg(exchk1,exchk2)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				local check=Duel.IsPlayerAffectedByEffect(tp,9910113) and c:IsCanOverlay()
					and Duel.IsExistingMatchingCard(QutryZcd.XFilter,tp,LOCATION_MZONE,0,1,nil,nil)
				if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
					and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
					and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsAbleToDeck() or check)
					and (exchk1 or exchk2(e,tp)) end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
			end
end
function QutryZcd.SpOp(beftd1,beftd2,afttd1,afttd2)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
				Duel.ConfirmDecktop(tp,1)
				local g=Duel.GetDecktopGroup(tp,1)
				local tc=g:GetFirst()
				if tc:IsSetCard(0x9958) and tc:IsType(TYPE_MONSTER) then
					if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
						and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not tc:IsForbidden() then
						Duel.DisableShuffleCheck()
						Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
						local e1=Effect.CreateEffect(c)
						e1:SetCode(EFFECT_CHANGE_TYPE)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
						e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
						tc:RegisterEffect(e1)
					end
				else
					local flag=false
					if not beftd1 then
						flag=beftd2(e,tp)
						if not flag then return end
					end
					local off=1
					local ops={}
					local opval={}
					local b1=c:IsAbleToDeck()
					local check=Duel.IsPlayerAffectedByEffect(tp,9910113) and c:IsCanOverlay()
					local xg=Duel.GetMatchingGroup(QutryZcd.XFilter,tp,LOCATION_MZONE,0,nil)
					if c:IsAbleToDeck() then
						ops[off]=aux.Stringid(9910100,1)
						opval[off-1]=1
						off=off+1
					end
					if check and #xg>0 then
						ops[off]=aux.Stringid(9910100,2)
						opval[off-1]=2
						off=off+1
					end
					if off==1 then return end
					local op=Duel.SelectOption(tp,table.unpack(ops))
					if opval[op]==1 then
						if flag then Duel.BreakEffect() end
						flag=Duel.SendtoDeck(c,nil,0,REASON_EFFECT)>0
					elseif opval[op]==2 then
						if flag then Duel.BreakEffect() end
						Duel.Hint(HINT_CARD,0,9910113)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
						local sg=xg:Select(tp,1,1,nil)
						Duel.HintSelection(sg)
						if sg:GetFirst():IsImmuneToEffect(e) then return end
						Duel.Overlay(sg:GetFirst(),Group.FromCards(c))
						flag=true
					end
					if flag and not afttd1 then afttd2(e,tp) end
				end
			end
end
