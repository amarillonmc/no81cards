--水魔女 阿库娅
function c10113052.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c10113052.fscon)
	e0:SetOperation(c10113052.fsop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10113052.splimit)
	c:RegisterEffect(e1) 
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10113052.sprcon)
	e2:SetOperation(c10113052.sprop)
	c:RegisterEffect(e2) 
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88264978,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c10113052.sptg)
	e3:SetOperation(c10113052.spop)
	c:RegisterEffect(e3)  
end
function c10113052.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10113052.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10113052.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c10113052.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10113052.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10113052.spfilter1(c,tp,ft)
	if c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(nil,true) and (c:IsControler(tp) or c:IsFaceup()) then
		if ft>0 or (c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)) then
			return Duel.IsExistingMatchingCard(c10113052.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,2,c,tp,nil)
		else
			return Duel.IsExistingMatchingCard(c10113052.spfilter3,tp,LOCATION_MZONE,0,1,c,tp,c)
		end
	else return false end
end
function c10113052.spfilter2(c,tp,rc)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup()) and c~=rc
end
function c10113052.spfilter3(c,tp,rc)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup()) and Duel.IsExistingMatchingCard(c10113052.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,2,c,tp,rc)
end
function c10113052.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c10113052.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,ft)
end
function c10113052.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10113052,1))
	local g1=Duel.SelectMatchingCard(tp,c10113052.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,ft)
	local tc=g1:GetFirst()
	local g=Duel.GetMatchingGroup(c10113052.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,tc,tp,nil)
	local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10113052,2))
	if ft>0 or (tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)) then
		g2=g:Select(tp,2,2,nil)
	else
		g2=g:FilterSelect(tp,Card.IsControler,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10113052,2))
		local g3=g:Select(tp,1,1,g2:GetFirst())
			  g2:Merge(g3)
	end
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c10113052.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c10113052.filter1(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c10113052.filter2(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c10113052.fscon(e,g,gc,chkfnf)
	if g==nil then return true end
	local f1=c10113052.filter1
	local f2=c10113052.filter2
	local minc=2
	local chkf=bit.band(chkfnf,0xff)
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler(),true) then return false end
		if aux.FConditionFilterFFR(gc,f1,f2,mg,minc,chkf) then
			return true
		elseif f2(gc) then
			mg:RemoveCard(gc)
			if aux.FConditionCheckF(gc,chkf) then chkf=PLAYER_NONE end
			return mg:IsExists(aux.FConditionFilterFFR,1,nil,f1,f2,mg,minc-1,chkf)
		else return false end
	end
	return mg:IsExists(aux.FConditionFilterFFR,1,nil,f1,f2,mg,minc,chkf)
end
function c10113052.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local f1=c10113052.filter1
	local f2=c10113052.filter2
	local chkf=bit.band(chkfnf,0xff)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
	local minct=2
	local maxct=2
	if gc then
		g:RemoveCard(gc)
		if aux.FConditionFilterFFR(gc,f1,f2,g,minct,chkf) then
			if aux.FConditionCheckF(gc,chkf) then chkf=PLAYER_NONE end
			local g1=Group.CreateGroup()
			if f2(gc) then
				local mg1=g:Filter(aux.FConditionFilterFFR,nil,f1,f2,g,minct-1,chkf)
				if mg1:GetCount()>0 then
					--if gc fits both, should allow an extra material that fits f1 but doesn't fit f2
					local mg2=g:Filter(f2,nil)
					mg1:Merge(mg2)
					if chkf~=PLAYER_NONE then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						local sg=mg1:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
						g1:Merge(sg)
						mg1:Sub(sg)
						minct=minct-1
						maxct=maxct-1
						if not f2(sg:GetFirst()) then
							if mg1:GetCount()>0 and maxct>0 and (minct>0 or Duel.SelectYesNo(tp,93)) then
								if minct<=0 then minct=1 end
								Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
								local sg=mg1:FilterSelect(tp,f2,minct,maxct,nil)
								g1:Merge(sg)
							end
							Duel.SetFusionMaterial(g1)
							return
						end
					end
					if maxct>1 and (minct>1 or Duel.SelectYesNo(tp,93)) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						local sg=mg1:FilterSelect(tp,f2,minct-1,maxct-1,nil)
						g1:Merge(sg)
						mg1:Sub(sg)
						local ct=sg:GetCount()
						minct=minct-ct
						maxct=maxct-ct
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local sg=mg1:Select(tp,1,1,nil)
					g1:Merge(sg)
					mg1:Sub(sg)
					minct=minct-1
					maxct=maxct-1
					if mg1:GetCount()>0 and maxct>0 and (minct>0 or Duel.SelectYesNo(tp,93)) then
						if minct<=0 then minct=1 end
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						local sg=mg1:FilterSelect(tp,f2,minct,maxct,nil)
						g1:Merge(sg)
					end
					Duel.SetFusionMaterial(g1)
					return
				end
			end
			local mg=g:Filter(f2,nil)
			if chkf~=PLAYER_NONE then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=mg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
				g1:Merge(sg)
				mg:Sub(sg)
				minct=minct-1
				maxct=maxct-1
			end
			if mg:GetCount()>0 and maxct>0 and (minct>0 or Duel.SelectYesNo(tp,93)) then
				if minct<=0 then minct=1 end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=mg:Select(tp,minct,maxct,nil)
				g1:Merge(sg)
			end
			Duel.SetFusionMaterial(g1)
			return
		else
			if aux.FConditionCheckF(gc,chkf) then chkf=PLAYER_NONE end
			minct=minct-1
			maxct=maxct-1
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=g:FilterSelect(tp,aux.FConditionFilterFFR,1,1,nil,f1,f2,g,minct,chkf)
	local mg=g:Filter(f2,g1:GetFirst())
	if chkf~=PLAYER_NONE and not aux.FConditionCheckF(g1:GetFirst(),chkf) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg=mg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
		g1:Merge(sg)
		mg:Sub(sg)
		minct=minct-1
		maxct=maxct-1
	end
	if mg:GetCount()>0 and maxct>0 and (minct>0 or Duel.SelectYesNo(tp,93)) then
		if minct<=0 then minct=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg=mg:Select(tp,minct,maxct,nil)
		g1:Merge(sg)
	end
	Duel.SetFusionMaterial(g1)
end
