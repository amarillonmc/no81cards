--融合幻象
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10150096)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"sp,tk",nil,nil,rscost.reglabel(100),cm.tg,cm.act)
	if cm.matlist then return end
	cm.matlist={}
	local ge1=rsef.FC({c,0},EVENT_ADJUST)
	ge1:SetOperation(cm.checkop)
end
function cm.cfilter(c)
	return c:IsType(TYPE_FUSION) and c.material and c:GetFlagEffect(m)<=0
end
function cm.checkop(e,tp)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,0xff,0xff,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,0,0,1)
		local list={}
		local reslist={}
		for mat,bool in pairs(tc.material) do 
			if type(mat)=="number" and not rsof.Table_List(list,mat) then 
				table.insert(list,mat) 
			end
		end
		for index,code in pairs(list) do 
			local tk=Duel.CreateToken(0,code)
			local race,att,lv,atk,def=tk:GetOriginalRace(),tk:GetOriginalAttribute(),tk:GetOriginalLevel(),tk:GetTextAttack(),tk:GetTextDefense()
			if lv<=0 then
				reslist={}
				break
			end
			table.insert(reslist,{code,race,att,lv,atk,def})
		end
		if #reslist>0 then
			cm.matlist[tc]=reslist
		end
	end
end
function cm.filter(c,tp)
	local list=cm.matlist[c]
	if not list or Duel.GetLocationCount(tp,LOCATION_MZONE)<#list or (#list>=2 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return false end
	for _,mat in pairs(list) do 
		local code,race,att,lv,atk,def=table.unpack(mat)
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,code,0,0x4011,atk,def,lv,race,att,POS_FACEUP_DEFENSE) then return false end
	end
	return true
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()==100 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.SetTargetCard(tc)
	local list=cm.matlist[tc]
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,#list,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#list,0,0)
end
function cm.act(e,tp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local tc=rscf.GetTargetCard()
	local list=cm.matlist[tc]
	if not cm.filter(tc,tp) then return end
	for _,mat in pairs(list) do 
		local code,race,att,lv,atk,def=table.unpack(mat)
		local tk=Duel.CreateToken(tp,86871615)  
		local e1=rsef.SV_LIMIT({c,tk,true},"ress",nil,nil,rsreset.est-RESET_TOFIELD)
		rscf.QuickBuff({c,tk,true},"code",code,"lv",lv,"race",race,"att",att,"batk",atk,"bdef",def,"rst",rsreset.est-RESET_TOFIELD)
		Duel.SpecialSummonStep(tk,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	if not c:IsLocation(LOCATION_EXTRA) then return false end
	local sc=se:GetHandler()
	return not se or not sc:IsSetCard(0x46) or not sc:IsType(TYPE_SPELL)
end
