--概念虚械 仁爱
local m=20000150
local cm=_G["c"..m]
fu_cim=fu_cim or {}
-------------------------------xyz
function fu_cim.XyzUnite(c,code,Give)
--xyz procedure
	--aux.AddXyzProcedureLevelFree(c,fu_cim.Xyz_Card_Filter,fu_cim.Xyz_Group_Filter,2,2)
	fu_cim.Xyz_Procedure(c,6)
	c:EnableReviveLimit()
--get material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(fu_cim.Remove_Material_cost)
	e1:SetTarget(fu_cim.GetMaterial_tg)
	e1:SetOperation(fu_cim.GetMaterial_op)
	c:RegisterEffect(e1)
--be remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE) --EVENT_DETACH_MATERIAL
	e2:SetCondition(fu_cim.GiveEffect_con(code))
	e2:SetOperation(fu_cim.GiveEffect_op(code,Give))
	c:RegisterEffect(e2)
	return e1,e2
end
-------------------------------
function fu_cim.Hint(c,code,con,cod)
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e1:SetCode(EVENT_ADJUST)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetOperation(fu_cim.Hint_op1(code))  
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(fu_cim.Hint_con2)
	e2:SetOperation(fu_cim.Hint_op2(code))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e5)
	if con then
		local e6=Effect.CreateEffect(c)
		e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
		if cod then
			e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
			e6:SetCode(EVENT_SPSUMMON_SUCCESS)
			e6:SetProperty(EFFECT_FLAG_DELAY)
		else
			e6:SetType(EFFECT_TYPE_IGNITION)
		end
		e6:SetRange(LOCATION_HAND)
		e6:SetCountLimit(1,code)
		e6:SetCondition(con)
		e6:SetTarget(fu_cim.Hand_Effect_tg)
		e6:SetOperation(fu_cim.Hand_Effect_op)
		c:RegisterEffect(e6)
		local e7=e6:Clone()
		e7:SetCost(fu_cim.Grave_Effect_cos)
		e7:SetRange(LOCATION_GRAVE)
		c:RegisterEffect(e7)
		return e6,e7
	end
end
function fu_cim.Remove_Material_condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0xcfd1) and c:IsType(TYPE_XYZ)
end
function fu_cim.Remove_Material_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(fu_cim.Remove_Material_cost_filter,tp,LOCATION_MZONE,0,nil,tp)
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20000162,2))
	local tc=g:Select(tp,1,1,nil):GetFirst()
	tc:RemoveOverlayCard(tp,1,1,REASON_COST)
end
-------------------------------
function fu_cim.Xyz_Procedure(c,rank)
	local minc=2
	local maxc=2
	if rank==12 then maxc=99 end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(fu_cim.Xyz_Procedure_con(minc,maxc))
	e1:SetTarget(fu_cim.Xyz_Procedure_tg(minc,maxc))
	e1:SetOperation(fu_cim.Xyz_Procedure_op(minc,maxc))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
--Xyz Summon(level free)
function fu_cim.Xyz_Procedure_con(minct,maxct)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				local tp=c:GetControler()
				local minc=minct
				local maxc=maxct
				if min then
					minc=math.max(minc,min)
					maxc=math.min(maxc,max)
				end
				if maxc<minc then return false end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,fu_cim.Xyz_Card_Filter(tp))
				else
					mg=Duel.GetMatchingGroup(Auxiliary.XyzLevelFreeFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,fu_cim.Xyz_Card_Filter(tp))
				end
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,minc,maxc,tp,c,fu_cim.Xyz_Group_Filter(c))
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function fu_cim.Xyz_Procedure_tg(minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,fu_cim.Xyz_Card_Filter(tp))
				else
					mg=Duel.GetMatchingGroup(Auxiliary.XyzLevelFreeFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,fu_cim.Xyz_Card_Filter(tp))
				end
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				Duel.SetSelectedCard(sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local g=mg:SelectSubGroup(tp,Auxiliary.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,fu_cim.Xyz_Group_Filter(c))
				Auxiliary.GCheckAdditional=nil
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function fu_cim.Xyz_Procedure_op(minct,maxct)
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
							Duel.Overlay(c,mg2)
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
					if mg:IsExists(Card.IsControler,1,nil,1-tp) then
						Duel.Hint(HINT_CODE,tp,20000167)
						Duel.RegisterFlagEffect(tp,20000167,RESET_PHASE+PHASE_END,0,1)
					end
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
function fu_cim.Xyz_Card_Filter(tp)
	return  function(c,xyzc)
				local rank=xyzc:GetRank()
				return (Duel.GetFlagEffect(tp,20000167)==1 and c:IsControler(1-tp)) 
					or (c:IsControler(tp) and ((not c:IsType(TYPE_LINK) and rank==6) or (c:IsType(TYPE_XYZ) and rank==12)))
			end
end
function fu_cim.Xyz_Group_Filter(c)
	return  function(g)
				local tp=c:GetControler()
				local rank=c:GetRank()
				local mg=g:Filter(Card.IsControler,nil,tp)
				local rg=g:Filter(Card.IsType,nil,TYPE_XYZ)
				local lg=Group.__bxor(mg,rg)
				return (Duel.GetFlagEffect(tp,20000167)==1 and g:FilterCount(Card.IsControler,nil,1-tp)==1 
					and rg:GetSum(Card.GetRank)+lg:GetSum(Card.GetLevel)==rank-3)
					or (not g:IsExists(Card.IsControler,1,nil,1-tp) and rg:GetSum(Card.GetRank)+lg:GetSum(Card.GetLevel)==rank)
			end
end
function fu_cim.GetMaterial_tgf(c)
	return c:IsCanOverlay() and c:IsType(TYPE_MONSTER)
end
function fu_cim.GetMaterial_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and fu_cim.GetMaterial_tgf(chkc) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(fu_cim.GetMaterial_tgf,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,fu_cim.GetMaterial_tgf,tp,LOCATION_GRAVE,0,1,1,nil)
end
function fu_cim.GetMaterial_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsType(TYPE_XYZ) then
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function fu_cim.GiveEffect_con(code)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
					and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():GetFlagEffect(code)==0
			end
end
function fu_cim.GiveEffect_op(code,Give)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local tc=re:GetHandler()
				if not tc:IsOnField() then return end
				if Give then 
					Give(tc)
					tc:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,0,1)
				end
			end
end
function fu_cim.Remove_Material_cost_filter(c,tp)
	return c:IsSetCard(0xcfd1) and c:IsType(TYPE_XYZ) and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function fu_cim.Hint_op(c,code)
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e1:SetCode(EVENT_ADJUST)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetOperation(fu_cim.Hint_op_op1(code))  
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(fu_cim.Hint_op_con2)
	e2:SetOperation(fu_cim.Hint_op_op2(code))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e5)
end
function fu_cim.Hint_op1(code)
	return  function(e,c)
				if e:GetHandler():IsSetCard(0xcfd1) and e:GetHandler():IsType(TYPE_XYZ) then
					e:GetHandler():RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,0))
				end
			end
end
function fu_cim.Hint_con2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousLocation(LOCATION_OVERLAY)  
end
function fu_cim.Hint_op2(code)
	return  function(e,c)
				local tp=e:GetHandler():GetControler() 
				local c=e:GetHandler() 
				local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_XYZ)
				local tc=g:GetFirst()
				while tc do
					tc:ResetFlagEffect(code)
					tc=g:GetNext()
				end
				Duel.Readjust()
			end
end
function fu_cim.Grave_Effect_cos_filter(c)
	return c:IsSetCard(0xcfd1) and c:IsType(TYPE_XYZ) and c:GetRank()>=3 and c:IsFaceup()
end
function fu_cim.Grave_Effect_cos(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(fu_cim.Grave_Effect_cos_filter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20000162,3))
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_RANK)
	e1:SetValue(-3)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	tc:RegisterEffect(e1)
end
function fu_cim.Hand_Effect_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function fu_cim.Hand_Effect_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(fu_cim.SpecialSummon_limit_tg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function fu_cim.SpecialSummon_limit_tg(e,c,sump,sumtype,sumpos,targetp,se)
	return not (((c:GetLevel()/3)>0 and (c:GetLevel()%3)==0) or ((c:GetRank()/3)>0 and (c:GetRank()%3)==0))
end
-------------------------------
if not cm then return end
function cm.initial_effect(c)
	local e1=fu_cim.XyzUnite(c,m,cm.Give)
end
function cm.Give(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetAttack()/2
	if chk==0 then return atk>0 end
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,2))
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and (c:GetAttack()/2)>0 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Recover(p,c:GetAttack()/2,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.op1va)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.op1va(e,re,dam,r,rp,rc)
	return math.floor(dam/2)
end